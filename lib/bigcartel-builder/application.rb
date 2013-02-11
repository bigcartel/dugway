require 'sprockets'

module BigCartel
  module Builder
    class Application
      SOURCE_DIR = File.join(Dir.pwd, 'source')
      IMAGE_REGEX = /\.(jpg|jpeg|png|gif|ico)$/
      HTML_REGEX = /\.html$/

      def call(env)
        request = Rack::Request.new(env)
        path = request.path
        file = path.split('/')[1] || 'home'
        file = file.include?('.') ? file : "#{ file }.html"
        
        if file =~ HTML_REGEX && page_html = content_for(file)
          type = 'html'
          body = Template.new(page_html, layout_html).render
        elsif file == 'styles.css'
          type = 'css'
          body = Template.new(sprockets[file].to_s).render
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
