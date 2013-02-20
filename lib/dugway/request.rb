require 'rack/request'

module Dugway
  class Request < Rack::Request
    def file_name
      "#{ permalink }#{ extension }"
    end
    
    def permalink
      case path
      when /^\/$/
        'home'
      when /^\/(products|category|artist)\//
        'products'
      when /^\/product\//
        'product'
      else
        File.basename(path[1..-1], '.*')
      end
    end
    
    def extension
      File.extname(path).present? ? File.extname(path) : '.html'
    end
    
    def html?
      extension == '.html'
    end
    
    def image?
      path =~ /^\/images\/.+\.(jpg|jpeg|gif|png)$/ ? true : false
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
