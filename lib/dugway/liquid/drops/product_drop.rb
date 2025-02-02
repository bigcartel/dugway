module Dugway
  module Drops
    class ProductDrop < BaseDrop
      def created_at
        Time.parse(source['created_at'])
      end

      def price
        nil # price is deprecated in favor of default_price
      end

      def min_price
        @min_price ||= price_min_max.first
      end

      def max_price
        @max_price ||= price_min_max.last
      end

      def variable_pricing
        @variable_pricing ||= min_price != max_price
      end

      def has_default_option
        @has_default_option ||= options.size == 1 && option.name.downcase == 'default'
      end

      def option
        @option ||= options.blank? ? nil : options.first
      end

      def options
        @options ||= source['options'].each_with_index.map { |o,i| ProductOptionDrop.new(o.update('position' => i+1, 'product' => self)) }
      end

      def options_in_stock
        @options_in_stock ||= options.reject { |o| o.sold_out }
      end

      def has_option_groups
        source['has_option_groups']
      end

      def option_groups
        @option_groups ||= source['option_groups'].present? ?
          source['option_groups'].map { |group| OptionGroupDrop.new(group) } : []
      end

      def shipping
        @shipping ||= source['shipping'].present? ? source['shipping'].map { |o| ShippingOptionDrop.new(o.update('product' => self)) } : []
      end

      def image
        @image ||= images.blank? ? nil : images.first
      end

      def images
        @images ||= source['images'].present? ? source['images'].map { |image| ImageDrop.new(image) } : []
      end

      def image_count
        @image_count ||= images.size
      end

      def previous_product
        @previous_product ||= begin
          if previous_product = store.previous_product(permalink)
            ProductDrop.new(previous_product)
          else
            nil
          end
        end
      end

      def next_product
        @next_product ||= begin
          if next_product = store.next_product(permalink)
            ProductDrop.new(next_product)
          else
            nil
          end
        end
      end

      def edit_url
        'http://bigcartel.com'
      end

      def categories
        @categories ||= source['categories'].map { |c| CategoryDrop.new(c) } rescue []
      end

      def artists
        @artists ||= source['artists'].map { |a| ArtistDrop.new(a) } rescue []
      end

      def css_class
        @css_class ||= begin
          c = 'product'
          c += ' sold' if status == 'sold-out'
          c += ' soon' if status == 'coming-soon'
          c += ' sale' if on_sale
          c
        end
      end

      def related_products
        @related_products ||= begin
          drop = RelatedProductsDrop.new(source)
          drop.context = @context if @context
          drop.products
        end
      end

      private

      def price_min_max
        @price_min_max ||= options.collect(&:price).uniq.minmax
      end
    end
  end
end
