module Dugway
  module Filters
    module UrlFilters
      def link_to(item, *args)
        options = link_args_to_options(args)
        text = options.delete(:text) || h(item['name'])
        options = { :title => "View #{ text }", :href => item['url'] }.merge(options)
        content_tag :a, text, options
      end

      def constrain(url = nil, width = 0, height = 0)
        image_url url, width, height if url
      end

      def product_image_url(image = nil, size = nil)
        url = image ? image['url'] : 'http://images.bigcartel.com/missing.png'
        size = legacy_size_for(size)
        image_url url, size, size
      end

      def theme_js_url(name)
        if name.is_a?(Drops::ThemeDrop)
          '/theme.js'
        elsif name == 'api'
          'http://cache0.bigcartel.com/api/1/api.usd.js'
        else
          name
        end
      end

      def theme_css_url(theme)
        '/theme.css'
      end

      def theme_image_url(filename)
        "/images/#{ filename }"
      end

      def theme_font_url(filename)
        "/fonts/#{ filename }"
      end

      private

      def link_args_to_options(args)
        options = {}

        [:text, :title, :id, :class, :rel].zip(args) { |key, value|
          options[key] = h(value)  unless value.nil?
        }

        options
      end

      def image_url(url, width, height)
        uri = URI.parse(url)
        query_hash = Rack::Utils.parse_nested_query uri.query
        uri.query = query_hash.update('w' => width, 'h' => height).to_query
        uri.to_s
      end

      def legacy_size_for(size)
        case size
        when 'large'  then 300
        when 'medium' then 175
        when 'thumb'  then 75
        else 1000
        end
      end
    end
  end
end
