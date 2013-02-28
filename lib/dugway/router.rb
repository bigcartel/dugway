require 'rack/mount'

module Dugway
  class Router
    class << self
      def routes
        @routes ||= Rack::Mount::RouteSet.new
      end

      def route(method, path, &block)
        if path.is_a?(String) && path =~ %r{^/(\w+)/:permalink}
          path = %r{^/#{ $1 }/(?<permalink>[a-z0-9\-_]+)$}
        end
        
        routes.add_route(Proc.new { |env| yield(Request.new(env)) }, { :request_method => method, :path_info => path })
        routes.rehash
      end

      def get(path, &block)
        route('GET', path, &block)
      end

      def post(path, &block)
        route('POST', path, &block)
      end

      def render_text(text)
        [200, {'Content-Type' => 'text/plain'}, [text]]
      end
    end

    def call(env)
      self.class.routes.call(env)
    end
  end
end
