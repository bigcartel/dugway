require 'rack/request'

module Dugway
  class Request < Rack::Request
    def params
      super.update(env['rack.routing_args']).symbolize_keys
    end
    
    def page_permalink
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
  end
end
