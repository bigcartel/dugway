require 'sprockets'

module BigCartel
  module Builder
    class Application
      SOURCE_DIR = File.join(Dir.pwd, 'source')
      IMAGE_REGEX = /\.(jpg|jpeg|png|gif|ico)$/
      HTML_REGEX = /\.html$/
      
      def initialize(options={})
        @store = Store.new(options[:store] || 'builder')
        @custom_settings = (options[:settings] || {}).stringify_keys
      end
      
      def call(env)
        path = Rack::Request.new(env).path
        file = path.split('/')[1] || 'home'
        file = file.include?('.') ? file : "#{ file }.html"
        
        if file =~ HTML_REGEX && page_html = content_for(file)
          type = 'html'
          body = render(page_html)
        elsif file == 'styles.css'
          type = 'css'
          body = render(sprockets[file].to_s, false)
        elsif file == 'scripts.js'
          type = 'javascript'
          body = sprockets[file].to_s
        elsif path =~ IMAGE_REGEX
          return Rack::File.new(SOURCE_DIR).call(env)
        end
        
        status = body ? 200 : 404
        headers = { 'Content-Type' => "text/#{ type || 'plain' }" }
        body = [body || 'Page not found']
        
        [status, headers, body]
      end
      
      private
      
      def render(content, use_layout=true)
        Template.new(@store, settings, content, use_layout ? layout_html : nil).render
      end
      
      def content_for(file_name)
        file_path = File.join(SOURCE_DIR, file_name)
        
        if File.exist?(file_path)
          File.open(file_path, "rb").read
        else
          nil
        end
      end
      
      def layout_html
        content_for('layout.html')
      end
      
      def settings
        if @settings.blank?
          @settings = {}
          
          json = JSON.parse(content_for('settings.json'))
          
          %w( fonts colors options ).each { |type|
            if json.has_key?(type)
              json[type].each { |setting|
                @settings[setting['variable']] = setting['default']
              }
            end
          }
          
          @settings.update(@custom_settings)
        end
        
        @settings
      end
      
      def sprockets
        if @sprockets.blank?
          @sprockets = Sprockets::Environment.new
          @sprockets.append_path SOURCE_DIR
        end
        
        @sprockets
      end
    end
  end
end
