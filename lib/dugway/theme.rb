require 'coffee-script'
require 'sass'
require 'less'
require 'sprockets'

module Dugway
  class Theme
    SOURCE_DIR = File.join(Dir.pwd, 'source')
    REQUIRED_FILES = %w( layout.html home.html products.html product.html cart.html checkout.html success.html contact.html maintenance.html scripts.js styles.css settings.json screenshot.jpg )
    
    def initialize(overridden_user_settings={})
      @overridden_user_settings = overridden_user_settings.stringify_keys
    end
    
    def find_template_by_request(request)
      name = request.file_name
      
      if request.html? && content = read_source_file(name)
        Template.new(name, content)
      elsif name == 'styles.css'
        Template.new(name, sprockets[name].to_s)
      elsif name == 'scripts.js'
        Template.new(name, sprockets[name].to_s, false)
      else
        nil
      end
    end
    
    def find_image_by_env(env)
      Rack::File.new(SOURCE_DIR).call(env)
    end
    
    def layout
      @layout ||= read_source_file('layout.html')
    end
    
    def settings
      @settings ||= JSON.parse(read_source_file('settings.json'))
    end
    
    def user_settings
      @user_settings ||= begin
        Hash.new.tap { |user_settings|
          %w( fonts colors options ).each { |type|
            if settings.has_key?(type)
              settings[type].each { |setting|
                user_settings[setting['variable']] = setting['default']
              }
            end
          }
        
          user_settings.update(@overridden_user_settings)
        }
      end
    end
    
    private
    
    def sprockets
      @sprockets ||= begin
        sprockets = Sprockets::Environment.new
        sprockets.append_path SOURCE_DIR
        sprockets
      end
    end
    
    def read_source_file(file_name)
      file_path = File.join(SOURCE_DIR, file_name)
      
      if File.exist?(file_path)
        File.open(file_path, "rb").read
      else
        nil
      end
    end
  end
end
