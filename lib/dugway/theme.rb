require 'coffee-script'
require 'sass'
require 'sprockets'
require 'sprockets-sass'
require 'compass'
require 'terser'

module Dugway
  class Theme
    REQUIRED_FILES = %w( cart.html contact.html home.html layout.html maintenance.html product.html products.html screenshot.jpg settings.json theme.css theme.js )

    THEME_COLOR_ATTRIBUTE_MAPPINGS = YAML.load_file(
      File.join(__dir__, 'config', 'theme_color_attribute_mappings.yml')
    ).freeze

    attr_reader :errors

    def initialize(overridden_customization={})
      @overridden_customization = overridden_customization.stringify_keys
    end

    def layout
      read_source_file('layout.html')
    end

    def settings
      JSON.parse(read_source_file('settings.json'))
    end

    def fonts
      customization_for_type('fonts')
    end

    def images
      customization_for_type('images')
    end

    def image_sets
      customization_for_type('image_sets')
    end

    def customization
      Hash.new.tap do |customization|
        %w( fonts colors options images image_sets ).each do |type|
          customization.update(customization_for_type(type))
        end

        customization.update(@overridden_customization)
      end
    end

    def name
      settings['name']
    end

    def version
      settings['version']
    end

    def file_content(name)
      case name
      when 'theme.js'
        if @building
          Terser.new.compile(sprockets[name].to_s)
        else
          sprockets[name].to_s
        end
      when 'theme.css'
        sprockets[name].to_s
      else
        read_source_file(name)
      end
    end

    def build_file(name)
      @building = true
      file_content(name)
    end

    def files
      REQUIRED_FILES + image_files + font_files
    end

    def image_files
      Dir.glob(File.join(source_dir, 'images', '**', '*.{png,jpg,jpeg,gif,ico,svg}')).map do |i|
        i.gsub(source_dir, '')[1..-1]
      end
    end

    def font_files
      Dir.glob(File.join(source_dir, 'fonts', '**', '*.{eot,ttf,otf,woff,svg}')).map do |i|
        i.gsub(source_dir, '')[1..-1]
      end
    end

    def valid?(validate_colors: true, validate_layout_attributes: true, validate_options: true)
      @errors = []

      REQUIRED_FILES.each do |file|
        @errors << "Missing source/#{ file }" if read_source_file(file).nil?
      end

      @errors << 'Missing theme name in source/settings.json' if name.blank?
      @errors << 'Invalid theme version in source/settings.json (ex: 1.0.3)' unless !!(version =~ /\d+\.\d+\.\d+/)

      if settings['preset_styles']
        validate_preview
        if settings['preset_styles']['presets']
          settings['preset_styles']['presets'].each do |preset|
            validate_preset_styles(preset)
            validate_style_references(preset)
          end
        else
          @errors << "Missing presets"
        end
      end

      validate_required_color_settings if validate_colors
      validate_required_layout_attributes if validate_layout_attributes
      validate_options_settings if validate_options

      @errors.empty?
    end

    def validate_required_color_settings
      required_colors_attribute_names = THEME_COLOR_ATTRIBUTE_MAPPINGS['required_color_attributes']

      theme_colors = settings['colors'].map { |c| c['variable'] }
      mappings = THEME_COLOR_ATTRIBUTE_MAPPINGS[name] || {}

      missing_colors = required_colors_attribute_names.reject do |color|
        theme_colors.include?(color) ||
        (mappings.key?(color) && (mappings[color].nil? || theme_colors.include?(mappings[color])))
      end

      unless missing_colors.empty?
        @errors << "Missing required color settings: #{missing_colors.join(', ')}"
      end
    end

    # Validate that the Layout file has expected attributes for:
    # - data-bc-page-type on the body tag
    # - one data-bc-hook="header" and one data-bc-hook="footer" somewhere
    def validate_required_layout_attributes
      layout_content = read_source_file('layout.html')

      unless layout_content =~ /<body.*?\bdata-bc-page-type\b/
        @errors << "layout.html missing `data-bc-page-type` attribute on body tag"
      end

      header_hooks = layout_content.scan(/data-bc-hook=(?:"|')header(?:"|')/).size
      footer_hooks = layout_content.scan(/data-bc-hook=(?:"|')footer(?:"|')/).size

      @errors << "layout.html must have exactly one `data-bc-hook=\"header\"`" if header_hooks != 1
      @errors << "layout.html must have exactly one `data-bc-hook=\"footer\"`" if footer_hooks != 1
    end

    def validate_options_settings
      return unless settings['options']

      validate_options_descriptions
      validate_options_requires
    end

    private

    def validate_preview
      preview = settings['preset_styles']['preview']
      if preview
        %w[title_font body_font text_color background_color].each do |key|
          @errors << "Missing #{key} in preview" unless preview[key]
        end
      else
        @errors << "Missing preview in preset_styles"
      end
    end

    def validate_preset_styles(preset)
      @errors << 'Preset is missing group_name' if preset['group_name'].to_s.strip.empty?
      @errors << 'Preset is missing styles' unless preset['styles'].is_a?(Array)

      preset['styles'].each do |style|
        @errors << "Style in group '#{preset['group_name']}' - Missing style_name" if style['style_name'].to_s.strip.empty?

        if style['fonts'].is_a?(Hash) && !style['fonts'].empty?
          style['fonts'].each_value do |font|
            @errors << "Style '#{style['style_name']} - Contains an invalid font name" if font.to_s.strip.empty?
          end
        else
          @errors << "Style '#{style['style_name']}' - Missing fonts"
        end

        if style['colors'].is_a?(Hash) && !style['colors'].empty?
          style['colors'].each do |key, color|
            unless color =~ /^#[0-9A-Fa-f]{6}$/
              @errors << "Style '#{style['style_name']}' - Invalid color value '#{color}' for color '#{key}'"
            end
          end
        else
          @errors << "Style '#{style['style_name']}' - Missing required color settings"
        end
      end

      validate_style_name_uniqueness(preset['styles'])
    end

    def validate_style_references(preset)
      ['fonts', 'colors'].each do |key_type|
        validate_keys(preset, settings[key_type], key_type)
      end
    end

    def validate_keys(preset, settings, key_type)
      variables = settings.map { |item| item['variable'] }

      preset['styles'].each do |style|
        style_keys = style[key_type].keys

        extra_keys = style_keys - variables
        missing_keys = variables - style_keys

        @errors << "Style '#{style['style_name']}' - Extra #{key_type} keys: #{extra_keys.join(', ')}" unless extra_keys.empty?
        @errors << "Style '#{style['style_name']}' - Missing #{key_type} keys: #{missing_keys.join(', ')}" unless missing_keys.empty?
      end
    end

    def validate_style_name_uniqueness(styles)
      duplicates = styles
        .group_by { |s| s['style_name'] }
        .select { |_, group| group.size > 1 }
        .keys

      @errors << "Duplicate style names found: #{duplicates.join(', ')}" if duplicates.any?
    end

    def validate_options_descriptions
      missing_descriptions = settings['options'].select { |option|
        option['description'].nil? || option['description'].strip.empty?
      }.map { |option| option['variable'] }

      @errors << "Missing descriptions for settings: #{missing_descriptions.join(', ')}" unless missing_descriptions.empty?
    end

    # Validate that any dependent settings are present in the theme settings
    def validate_options_requires
      return unless settings['options']
      all_variables = settings['options'].map { |o| o['variable'] }

      settings['options'].each do |option|
        next unless option['requires']

        # Handle case where requires is a string
        if option['requires'].is_a?(String)
          next if option['requires'] == 'inventory'
          unless all_variables.include?(option['requires'])
            @errors << "Option '#{option['variable']}' requires unknown setting '#{option['requires']}'"
          end
          next
        end

        # Validate requires is either a string or array
        unless option['requires'].is_a?(Array)
          @errors << "Option '#{option['variable']}' requires must be string 'inventory' or array of rules"
          next
        end

        # Process each rule in the array
        option['requires'].each do |rule|
          next if rule == 'inventory'

          # Extract setting name from rule
          # Handle both simple cases ("show_search") and complex cases ("show_search eq true")
          setting_name = if rule.include?(' ')
            rule.split(/\s+/).first
          else
            rule
          end

          # Verify the referenced setting exists
          unless all_variables.include?(setting_name)
            @errors << "Option '#{option['variable']}' requires unknown setting '#{setting_name}'"
          end
        end
      end
    end


    def source_dir
      Dugway.source_dir
    end

    def sprockets
      @sprockets ||= begin
        sprockets = Sprockets::Environment.new
        sprockets.append_path source_dir

        Sprockets::Sass.options[:line_comments] = false

        sprockets.register_preprocessor 'text/css', :liquifier do |context, data|
          @building ? data : Liquifier.render_styles(data)
        end

        sprockets
      end
    end

    def read_source_file(file_name)
      file_path = File.join(source_dir, file_name)

      if File.exist?(file_path)
        File.read(file_path)
      else
        nil
      end
    end

    def customization_for_type(type)
      Hash.new.tap do |hash|
        if settings.has_key?(type)
          case type
          when 'images'
            settings[type].each do |setting|
              if name = setting['default']
                hash[setting['variable']] = { :url => image_path_from_setting_name(name), :width => 1, :height => 1 }
              end
            end
          when 'image_sets'
            settings[type].each do |setting|
              if defaults = setting['default'] || setting['defaults']
                hash[setting['variable']] ||= []
                defaults.each do |name|
                  hash[setting['variable']] << { :url => image_path_from_setting_name(name), :width => 1, :height => 1 }
                end
              end
            end
          else
            settings[type].each do |setting|
              hash[setting['variable']] = setting['default']
            end
          end
        end
      end
    end

    def image_path_from_setting_name(name)
      image_files.detect { |path| path =~ /#{ Regexp.escape(name) }$/ }
    end
  end
end
