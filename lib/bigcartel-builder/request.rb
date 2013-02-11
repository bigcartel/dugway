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
    end
  end
end
