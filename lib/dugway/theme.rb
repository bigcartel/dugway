require 'coffee-script'
require 'sass'
require 'sprockets'
require 'sprockets-sass'
require 'compass'
require 'uglifier'

module Dugway
  class Theme
    REQUIRED_FILES = %w( cart.html checkout.html contact.html home.html layout.html maintenance.html product.html products.html screenshot.jpg success.html theme.css theme.js )
    SETTINGS_FILES = %w( settings.coffee settings.json )
    attr_reader :errors

    def initialize(overridden_customization={})
      @overridden_customization = overridden_customization.stringify_keys
    end

    def layout
      read_source_file('layout.html')
    end

    def settings_file
      SETTINGS_FILES.select { |file| !read_source_file(file).nil? }.first
    end

    def coffee_settings
      coffee = CoffeeScript.compile(read_source_file(settings_file), {bare: true})
      # remove the surrounding (); from compiled CoffeeScript
      coffee.gsub!(/\A\(\{/, '{').gsub!(/\}\)\;\Z/, '}')
      # ensure quoted keys
      coffee.gsub!(/^\s*([\w]+):/, '"\1":')
    end

    def settings
      if settings_file =~ /\.coffee\z/
        JSON.parse(coffee_settings)
      else
        JSON.parse(read_source_file(settings_file))
      end
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
      when 'theme.js'
        if @building
          Uglifier.new.compile(sprockets[name].to_s)
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
      REQUIRED_FILES + image_files << settings_file
    end

    def image_files
      Dir.glob(File.join(source_dir, 'images', '**', '*.{png,jpg,jpeg,gif,ico,svg}')).map { |i|
        i.gsub(source_dir, '')[1..-1]
      }
    end

    def valid?
      @errors = []

      REQUIRED_FILES.each { |file|
        @errors << "Missing source/#{ file }" if read_source_file(file).nil?
      }
      if SETTINGS_FILES.all? { |file| read_source_file(file).nil? }
        @errors << "Missing settings file (source/settings.coffee OR source/settings.json"
      end

      @errors << 'Missing theme name in source/settings.[coffee/json]' if name.blank?
      @errors << 'Invalid theme version in source/settings.[coffee/json] (ex: 1.0.3)' unless !!(version =~ /\d+\.\d+\.\d+/)
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
