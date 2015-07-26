module Dugway
  class PathInterpreter
    attr_accessor :path

    def initialize(path)
      @path = path
    end

    def call
      return path unless path.is_a?(String)
      case path
      when category_artist_or_product_path
        %r{^/#{$1}/(?<#{$2}>#{permalink_regex})#{format_regex}$}
      when product_or_cart_path
        %r{^/#{$1}#{format_regex}$}
      when custom_page_path
        %r{^/(?<#{$1}>#{permalink_regex})$}
      else
        %r{^#{path}$}
      end
    end

    private

    def permalink_regex
      %r{[a-z0-9\-_]+}
    end

    def format_regex
      %r{(\.(?<format>js))?}
    end

    def category_artist_or_product_path
      %r{^/(\w+)/:(#{permalink_regex})\(\.js\)}
    end

    def product_or_cart_path
      %r{^/(\w+)\(\.js\)$}
    end

    def custom_page_path
      %r{^/:(#{permalink_regex})}
    end
  end
end
