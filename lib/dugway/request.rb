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
    
    def format
      params[:format] || 'html'
    end
    
    def html?
      format == 'html'
    end

    def js?
      format == 'js'
    end
  end
end
