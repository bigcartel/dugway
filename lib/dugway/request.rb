module Dugway
  class Request < Rack::Request
    def params
      super.update(env['rack.routing_args']).symbolize_keys
    end
    
    def page_permalink
      case path
      when %r{^/$}
        'home'
      when %r{^/(products|category|artist)/}
        'products'
      when %r{^/product/}
        'product'
      else
        File.basename(path[1..-1], '.*')
      end
    end
    
    def extension
      File.extname(path).present? ? File.extname(path) : '.html'
    end
    
    def format
      params[:format] || extension[1..-1]
    end
    
    def html?
      format == 'html'
    end

    def js?
      format == 'js'
    end
  end
end
