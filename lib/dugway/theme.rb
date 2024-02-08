require 'coffee-script'
require 'sass'
require 'sprockets'
require 'sprockets-sass'
require 'compass'
require 'terser'

module Dugway
  class Theme
    REQUIRED_FILES = %w( cart.html contact.html home.html layout.html maintenance.html product.html products.html screenshot.jpg settings.json theme.css theme.js )

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

    def valid?
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

      @errors.empty?
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
      @errors << 'Preset is missing group_name' unless preset['group_name'].is_a?(String)
      @errors << 'Preset is missing styles' unless preset['styles'].is_a?(Array)

      preset['styles'].each do |style|
        @errors << 'Style is missing style_name' unless style['style_name'].is_a?(String)

        if style['fonts'].is_a?(Hash) && !style['fonts'].empty?
          style['fonts'].each_value do |font|
            @errors << 'Font value should be a string' unless font.is_a?(String)
          end
        else
          @errors << 'Style is missing fonts'
        end

        if style['colors'].is_a?(Hash) && !style['colors'].empty?
          style['colors'].each do |key, color|
            @errors << 'Invalid color format' unless color =~ /^#[0-9A-Fa-f]{6}$/
          end
        else
          @errors << 'Style is missing colors'
        end
      end

      @errors << 'Style names should be unique' unless preset['styles'].map { |style| style['style_name'] }.uniq.length == preset['styles'].length
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

        @errors << "Extra #{key_type} keys: #{extra_keys.join(', ')}" unless extra_keys.empty?
        @errors << "Missing #{key_type} keys: #{missing_keys.join(', ')}" unless missing_keys.empty?
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
