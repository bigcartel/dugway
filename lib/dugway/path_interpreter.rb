module Dugway
  class PathInterpreter
    attr_accessor :path

    PERMALINK_REGEX = %r{[a-z0-9\-_]+}
    FORMAT_REGEX = %r{(\.(?<format>js))?}

    def initialize(path)
      @path = path
    end

    def call
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
  end
end
