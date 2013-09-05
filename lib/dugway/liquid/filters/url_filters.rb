module Dugway
  module Filters
    module UrlFilters
      def link_to(item, *args)
        options = link_args_to_options(args)
        text = options.delete(:text) || h(item['name'])
        options = { :title => "View #{ text }", :href => item['url'] }.merge(options)
        content_tag :a, text, options
      end

      def product_image_url(image = nil, size = nil)
        width, height = legacy_size_for(size)

        if image.blank?
          image_url_hash('http://images.cdn.bigcartel.com/missing/-/missing.png', height, width)
        else
          image_url_hash(image['url'], height, width)
        end
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

      protected
      def image_url_hash(url, max_h = 1000, max_w = 1000)
        url.gsub!(/\/-\//, "/max_h-#{ max_h }+max_w-#{ max_w }/")
        url
      end

      def legacy_size_for(size)
        Hash.new([ 1000, 1000 ]).merge({
          thumb: [ 75, 75 ],
          medium: [ 175, 175 ],
          large: [ 300, 300 ]
        })[size.to_sym]
      end
    end
  end
end
