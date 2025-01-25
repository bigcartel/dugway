module Dugway
  module Drops
    class RelatedProductsDrop < BaseDrop
      def initialize(product)
        super()
        @product = product
      end

      def products
        fetch_related_products
      end

      private

      def settings
        @settings ||= theme.customization
      end

      def limit
        @limit ||= begin
          if settings
            limit = settings['similar_products'] ||
                    settings['related_items'] ||
                    settings['related_products'] ||
                    settings['number_related_products'] ||
                    4
            limit
          else
            4
          end
        end
      end

      def sort_order
        @sort_order ||= begin
          if settings
            order = settings['related_products_order'] ||
                    settings['similar_products_order'] ||
                    "position"
            order
          else
            "position"
          end
        end
      end

      def fetch_related_products
        return [] unless @product

        category_products = sort_products(fetch_category_products).take(limit)
        return category_products if category_products.size >= limit

        remaining_limit = limit - category_products.size
        fallback_products = sort_products(fetch_fallback_products(category_products, remaining_limit)).take(remaining_limit)

        category_products + fallback_products
      end

      def fetch_category_products
        # Filter Dugway's product data to match the categories of the current product
        Dugway.store.products.select do |product|
          product_cats = product['category_ids'] || []
          current_cats = @product['category_ids'] || []
          (product_cats & current_cats).any? && product['id'] != @product['id']
        end.map { |p| ProductDrop.new(p) }
      end

      def fetch_fallback_products(category_products, limit)
        # Get additional products excluding already included ones
        excluded_ids = category_products.map { |p| p['id'] } + [@product['id']]
        Dugway.store.products
          .reject { |product| excluded_ids.include?(product['id']) }
          .map { |p| ProductDrop.new(p) }
      end

      def sort_products(products)
        case sort_order
        when 'date', 'newest'
          products.sort { |a,b| b.source['id'] <=> a.source['id'] }
        when 'sales', 'sells', 'top-selling', 'views'
          products.shuffle
        else
          products.sort_by { |p| p.source['position'] }
        end
      end
    end
  end
end
