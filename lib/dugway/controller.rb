require 'rack/mount'

module Dugway
  class Controller
    class << self
      def routes
        @routes ||= Rack::Mount::RouteSet.new
      end

      def route(method, path, &block)
        path = interpret_path(path)

        routes.add_route(Proc.new { |env|
          @page = nil
          @request = Request.new(env)

          if request.html? && page.blank?
            render_not_found
          else
            yield
          end
        }, { 
          :request_method => method, 
          :path_info => path 
        })
        
        routes.rehash
      end

      def interpret_path(path)
        permalink = %r{[a-z0-9\-_]+}
        format = %r{(\.(?<format>[a-z]+))?}

        if path.is_a?(String)
          case path
          when %r{^/(\w+)/:(#{ permalink })}
            %r{^/#{ $1 }/(?<#{ $2 }>#{ permalink })#{ format }$}
          when %r{^/:(#{ permalink })}
            %r{^/(?<#{ $1 }>#{ permalink })#{ format }$}
          else
            %r{^#{ path }#{ format }$}
          end
        else
          path
        end
      end

      def get(path, &block)
        route('GET', path, &block)
      end

      def post(path, &block)
        route('POST', path, &block)
      end

      def any(path, &block)
        get(path, &block)
        post(path, &block)
      end

      def request
        @request
      end

      def params
        request.params
      end

      def store
        Dugway.store
      end

      def cart
        Dugway.cart
      end

      def page
        @page ||= begin
          if request.html? && page = Dugway.store.page(request.page_permalink)
            page['url'] = request.path
            page['full_url'] = request.url
            page['full_path'] = request.fullpath
            page
          else
            nil
          end
        end
      end

      def render_text(text)
        [200, {'Content-Type' => 'text/plain'}, [text]]
      end

      def render_not_found
        [404, {'Content-Type' => 'text/plain'}, ['Not Found']]
      end
    end

    def call(env)
      self.class.routes.call(env)
    end
  end
end
