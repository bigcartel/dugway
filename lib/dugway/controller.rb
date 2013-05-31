require 'rack/mount'

module Dugway
  class Controller
    PERMALINK_REGEX = %r{[a-z0-9\-_]+}
    FORMAT_REGEX = %r{(\.(?<format>js))?}

    class << self
      def routes
        @routes ||= Rack::Mount::RouteSet.new
      end

      private

      def route(method, path, &block)
        routes.add_route(Proc.new { |env|
          @page = nil
          @request = Request.new(env)
          @response = Rack::Response.new

          if request.html? && page.blank?
            render_not_found
          else
            yield
          end
        }, {
          :request_method => method,
          :path_info => interpret_path(path)
        })

        routes.rehash
      end

      def interpret_path(path)
        if path.is_a?(String)
          case path
          # category/artist/product
          when %r{^/(\w+)/:(#{ PERMALINK_REGEX })\(\.js\)}
            %r{^/#{ $1 }/(?<#{ $2 }>#{ PERMALINK_REGEX })#{ FORMAT_REGEX }$}
          # products/cart
          when %r{^/(\w+)\(\.js\)$}
            %r{^/#{ $1 }#{ FORMAT_REGEX }$}
          # custom pages
          when %r{^/:(#{ PERMALINK_REGEX })}
            %r{^/(?<#{ $1 }>#{ PERMALINK_REGEX })$}
          # everything else
          else
            %r{^#{ path }$}
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

      def response
        @response
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
          if page = Dugway.store.page(request.page_permalink)
            page['url'] = request.path
            page['full_url'] = request.url
            page['full_path'] = request.fullpath
            page
          else
            nil
          end
        end
      end

      def error(msg)
        request.session[:errors] ||= []
        request.session[:errors] << msg
      end

      def render_file(file_name, variables={})
        if errors = request.session.delete(:errors)
          variables.merge!(:errors => errors)
        end

        template = Template.new(file_name)
        content = template.render(request, variables)

        response.write(content)
        response['Content-Type'] = template.content_type
        response.finish
      end

      def render_page(variables={})
        render_file("#{ page['permalink'] }.html", variables.update({ :page => page }))
      end

      def render_json(object)
        response.write(object.to_json)
        response['Content-Type'] = 'application/json'
        response.finish
      end

      def render_not_found
        response.write('Not Found')
        response.status = 404
        response.finish
      end

      def redirect_to(path)
        response.redirect(path)
        response.finish
      end
    end

    def call(env)
      self.class.routes.call(env)
    end
  end
end
