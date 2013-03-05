module Dugway
  class Template
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def content
      Dugway.theme.file_content(name)
    end
    
    def content_type
      Rack::Mime.mime_type(extension)
    end
    
    def extension
      File.extname(name)
    end
    
    def html?
      extension == '.html'
    end
    
    def standalone_html?
      html? && !!(content =~ /\{\{\s*head_content\s*\}\}/)
    end
    
    def render(request, variables={})
      if html?
        liquifier = Liquifier.new(request)
        content_to_render = variables[:page] && variables[:page]['content'] || content
        rendered_content = liquifier.render(content_to_render, variables)
        
        if standalone_html?
          rendered_content
        else
          liquifier.render(Dugway.theme.layout, variables.update(:page_content => rendered_content))
        end
      else
        content
      end
    end
  end
end
