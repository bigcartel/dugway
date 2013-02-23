module Dugway
  class Template
    def initialize(name, content, liquify=true)
      @name = name
      @content = content
      @liquify = liquify
    end
    
    def content_type
      Rack::Mime.mime_type(extension)
    end
    
    def extension
      File.extname(@name)
    end
    
    def liquify?
      @liquify
    end
    
    def standalone?
      extension != '.html' || !!(@content =~ /\{\{\s*head_content\s*\}\}/)
    end
    
    def styles?
      @name == 'styles.css'
    end
    
    def success_page?
      @name == 'success.html'
    end
    
    def render(theme, store, request)
      # Simulate the "One moment..." page
      sleep(3) if request.post? && success_page?
      
      if liquify?
        liquifier = Liquifier.new(theme, store, request)
        rendered_content = liquifier.render @content, {}, styles?
        
        if standalone?
          rendered_content
        else
          liquifier.render theme.layout, 'page_content' => rendered_content
        end
      else
        @content
      end
    end
  end
end
