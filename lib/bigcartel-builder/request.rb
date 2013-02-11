require 'rack/request'

module BigCartel
  module Builder
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
      
      def page
        {}
      end
      
      def product
        {}
      end
      
      def category
        {}
      end
      
      def artist
        {}
      end
      
      def html?
        !path.include?('.')
      end
      
      def image?
        path =~ /^\/images\/.+\.(jpg|jpeg|gif|png)$/
      end
    end
  end
end
