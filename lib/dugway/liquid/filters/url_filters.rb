module Dugway
  module Filters
    module UrlFilters
      def link_to(item, *args)
        options = link_args_to_options(args)
        text = options.delete(:text) || h(item['name'])
        options = { :title => "View #{ text }", :href => item['url'] }.merge(options)
        content_tag :a, text, options
      end

      # To get max_w-100
      # Eg product.primary_image | product_image_url | constrain : '100'
      # To get max_h-100
      # Eg product.primary_image | product_image_url | constrain : '-', '100'
      # To get max_h-100+max_w-100
      # Eg product.primary_image | product_image_url | constrain : '100', '100'
      def constrain(url = nil, width = 0, height = 0)
        if url
          parsed_url = URI.parse(url)
          path_parts = parsed_url.path.split('/')

          width = width.to_i
          height = height.to_i

          path_parts.slice(-2).tap do |size|
            unless width == 0 && height == 0
              size.gsub!(/(max_w-)\d+/) do |match|
                width == 0 ? '' : "#{ $1 }#{ width }"
              end

              size.gsub!(/(max_h-)\d+/) do |match|
                height == 0 ? '' : "#{ $1 }#{ height }"
              end

              size.gsub!(/\+/, '') if width == 0 || height == 0
            end
          end

          parsed_url.path = path_parts.join('/')
          parsed_url.to_s
        end
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

      protected
      def image_url_hash(url, max_h = 1000, max_w = 1000)
        url = url.gsub(/\/-\//, "/max_h-#{ max_h }+max_w-#{ max_w }/")
        url
      end

      def legacy_size_for(size)
        size = size.present? ? size : :original

        Hash.new([ 1000, 1000 ]).merge({
          thumb: [ 75, 75 ],
          medium: [ 175, 175 ],
          large: [ 300, 300 ]
        })[size.to_sym]
      end
    end
  end
end
