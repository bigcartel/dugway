require 'coffee-script'
require 'sass'
require 'less'
require 'sprockets'
require 'uglifier'

module Dugway
  class Theme
    REQUIRED_FILES = %w( layout.html home.html products.html product.html cart.html checkout.html success.html contact.html maintenance.html scripts.js styles.css settings.json screenshot.jpg )

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

    def customization
      Hash.new.tap { |customization|
        %w( fonts colors options ).each { |type|
          customization.update(customization_for_type(type))
        }

        customization.update(@overridden_customization)
      }
    end

    def name
      settings['name']
    end

    def version
      settings['version']
    end

    def file_content(name)
      case name
      when 'scripts.js'
        if @building
          Uglifier.new.compile(sprockets[name].to_s)
        else
          sprockets[name].to_s
        end
      when 'styles.css'
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
      REQUIRED_FILES + image_files
    end

    def image_files
      Dir.glob(File.join(source_dir, 'images', '**', '*.{png,jpg,jpeg,gif}')).map { |i|
        i.gsub(source_dir, '')[1..-1]
      }
    end

    def valid?
      @errors = []

      REQUIRED_FILES.each { |file|
        @errors << "Missing source/#{ file }" if read_source_file(file).nil?
      }

      @errors << 'Missing theme name in source/settings.json' if name.blank?
      @errors << 'Invalid theme version in source/settings.json (ex: 1.0.3)' unless !!(version =~ /\d+\.\d+\.\d+/)
      @errors << 'Missing images in source/images' if image_files.empty?

      @errors.empty?
    end

    private

    def source_dir
      Dugway.source_dir
    end

    def sprockets
      @sprockets ||= begin
        sprockets = Sprockets::Environment.new
        sprockets.append_path source_dir

        # CSS engines like Sass and LESS choke on Liquid variables, so here we render the Liquid
        # if we're viewing the file, or escape and unescape it if we're building the file.

        sprockets.register_preprocessor 'text/css', :liquifier do |context, data|
          if @building
            Liquifier.escape_styles(data)
          else
            Liquifier.render_styles(data)
          end
        end

        sprockets.register_postprocessor 'text/css', :liquifier do |context, data|
          if @building
            Liquifier.unescape_styles(data)
          else
            data
          end
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
      Hash.new.tap { |hash|
        if settings.has_key?(type)
          settings[type].each { |setting|
            hash[setting['variable']] = setting['default']
          }
        end
      }
    end
  end
end
