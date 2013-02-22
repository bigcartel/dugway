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
        unless image.blank?
          url = image['url']

          unless size.blank?
            size = size.to_s.downcase

            if thumb_size_in_pixels = thumb_size_in_pixels_for(size)
              dir = url[0..url.rindex('/')]
              ext = File.extname(url)
              url = "#{ dir }#{ thumb_size_in_pixels }#{ ext }"
            end
          end
        else
          url = "http://bigcartel.com/images/common/noimage-#{ (size || 'large').to_s }.gif"
        end

        url
      end

      def theme_js_url(name)
        if name.is_a?(Drops::ThemeDrop)
          '/scripts.js'
        elsif name == 'api'
          'http://cache0.bigcartel.com/api/1/api.usd.js'
        else
          name
        end
      end

      def theme_css_url(theme)
        '/styles.css'
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
