module Dugway
  module Drops
    class CartItemDrop < BaseDrop 
      def price
        unit_price * quantity
      end

      def product
        ProductDrop.new(source['product'])
      end

      def option
        ProductOptionDrop.new(source['option'])
      end
    end
  end
end
