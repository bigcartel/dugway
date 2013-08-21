module Dugway
  module Filters
    module UrlFilters
      def link_to(item, *args)
        options = link_args_to_options(args)
        text = options.delete(:text) || h(item['name'])
        options = { :title => "View #{ text }", :href => item['url'] }.merge(options)
        content_tag :a, text, options
      end

      def product_image_url(image=nil, size=nil)
        thumb_size_in_pixels = thumb_size_in_pixels_for(size)
        if image.blank?
          url = "http://images.cdn.bigcartel.com/missing/max_h-#{thumb_size_in_pixels || 300}+max_w-#{thumb_size_in_pixels || 300}/missing.png"
        else
          url = image['url'].sub(/\/-\//, "/max_h-#{thumb_size_in_pixels || 1000}+max_w-#{thumb_size_in_pixels || 1000}/")
        end

        url
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

      private

      def link_args_to_options(args)
        options = {}

        [:text, :title, :id, :class, :rel].zip(args) { |key, value|
          options[key] = h(value)  unless value.nil?
        }

        options
      end

      def thumb_size_in_pixels_for(size)
        { 'thumb' => 75, 'medium' => 175, 'large' => 300 }[size]
      end
    end
  end
end
