module Dugway
  class Template
    def initialize(name, content)
      @name = name
      @content = content
    end
    
    def content_type
      Rack::Mime.mime_type(extension)
    end
    
    def extension
      File.extname(@name)
    end
    
    def html?
      extension == '.html'
    end
    
    def standalone_html?
      html? && !!(@content =~ /\{\{\s*head_content\s*\}\}/)
    end
    
    def success_page?
      @name == 'success.html'
    end
    
    def render(theme, store, request)
      # Simulate the "One moment..." page
      sleep(3) if request.post? && success_page?
      
      if html?
        liquifier = Liquifier.new(theme, store, request)
        rendered_content = liquifier.render(@content)
        
        if standalone_html?
          rendered_content
        else
          liquifier.render(theme.layout, 'page_content' => rendered_content)
        end
      else
        @content
      end
    end
  end
end
