require 'coffee-script'
require 'sass'
require 'less'
require 'sprockets'
require 'yui/compressor'

module Dugway
  class Theme
    REQUIRED_FILES = %w( layout.html home.html products.html product.html cart.html checkout.html success.html contact.html maintenance.html scripts.js styles.css settings.json screenshot.jpg )
    
    attr_reader :errors

    def initialize(source_dir, overridden_customization={})
      @source_dir = source_dir
      @overridden_customization = overridden_customization.stringify_keys
    end
    
    def find_template_by_request(request)
      name = request.file_name
      
      if request.html? && content = read_source_file(name)
        Template.new(name, content)
      elsif %w( styles.css scripts.js ).include?(name)
        Template.new(name, sprockets[name].to_s)
      else
        nil
      end
    end
    
    def find_image_by_env(env)
      Rack::File.new(@source_dir).call(env)
    end
    
    def layout
      @layout ||= read_source_file('layout.html')
    end
    
    def settings
      @settings ||= JSON.parse(read_source_file('settings.json'))
    end
    
    def fonts
      @fonts ||= customization_for_type('fonts')
    end
    
    def customization
      @customization ||= begin
        Hash.new.tap { |customization|
          %w( fonts colors options ).each { |type|
            customization.update(customization_for_type(type))
          }
        
          customization.update(@overridden_customization)
        }
      end
    end
    
    def name
      @name ||= settings['name']
    end
    
    def version
      @version ||= settings['version']
    end
    
    def build_file(name)
      @building = true
      
      case name
      when 'scripts.js'
        YUI::JavaScriptCompressor.new.compress(sprockets[name].to_s)
      when 'styles.css'
        sprockets[name].to_s
      else
        read_source_file(name)
      end
    end

    def files
      REQUIRED_FILES + image_files
    end

    def image_files
      Dir.glob(File.join(@source_dir, 'images', '**', '*.{png,jpg,jpeg,gif}')).map { |i| 
        i.gsub(@source_dir, '')[1..-1]
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
    
    def sprockets
      @sprockets ||= begin
        sprockets = Sprockets::Environment.new
        sprockets.append_path @source_dir
        
        # CSS engines like Sass and LESS choke on Liquid variables, so here we render the Liquid 
        # if we're viewing the file, or escape and unescape it if we're building the file.
        
        sprockets.register_preprocessor 'text/css', :liquifier do |context, data|
          if @building
            Liquifier.escape_styles(data)
          else
            Liquifier.render_styles(data, self)
          end
        end
        
        sprockets.register_postprocessor 'text/css', :liquifier do |context, data|
          if @building
            Liquifier.unescape_styles(data)
          end
        end
        
        sprockets
      end
    end
    
    def read_source_file(file_name)
      file_path = File.join(@source_dir, file_name)
      
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
