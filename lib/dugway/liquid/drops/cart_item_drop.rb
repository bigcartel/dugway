module Dugway
  module Drops
    class CartItemDrop < BaseDrop 
      def price
        unit_price * quantity
      end

      def total
        price + shipping
      end

      def product
        ProductDrop.new(source['product'])
      end

      def option
        ProductOptionDrop.new(source['option'])
      end

      def shipping
        0.0
      end
    end
  end
end
