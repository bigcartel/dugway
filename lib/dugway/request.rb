require 'rack/request'

module Dugway
  class Request < Rack::Request
    def file_name
      html? ? "#{ permalink }.html" : permalink
    end
    
    def permalink
      @permalink ||= begin
        case path
        when /^\/$/
          'home'
        when /^\/(products|category|artist)\//
          'products'
        when /^\/product\//
          'product'
        else
          path[1..-1]
        end
      end
    end
    
    def extension
      File.extname(path)
    end
    
    def html?
      extension.blank? || extension == '.html'
    end
    
    def image?
      path =~ /^\/images\/.+\.(jpg|jpeg|gif|png)$/
    end
    
    def custom_page?
      !Theme::REQUIRED_FILES.include?(file_name)
    end
    
    def product_permalink
      find_permalink('product')
    end
    
    def category_permalink
      find_permalink('category')
    end
    
    def artist_permalink
      find_permalink('artist')
    end
    
    private
    
    def find_permalink(type)
      path.scan(/\/#{ type }\/([a-z-]+)$/).try(:first).try(:first)
    end
  end
end
