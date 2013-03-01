module Dugway
  module Drops
    class CartDrop < BaseDrop
      def items
        @items ||= source.items.map { |item| CartItemDrop.new(item) }
      end

      def price
        nil # price is deprecated in favor of subtotal
      end
    end
  end
end
