module Dugway
  module Drops
    class CartDrop < BaseDrop
      def items
        @items ||= source.items.map { |item| CartItemDrop.new(item) }
      end

      def item_count
        items.map { |item| item['quantity'] }.inject(:+) || 0
      end

      def total
        items.map { |item| item['price'] }.inject(:+) || 0
      end

      def country
        nil
      end

      def shipping
        { 
          'enabled' => false,
          'amount' => 0.00,
          'strict' => false,
          'pending' => false
        }
      end

      def tax
        { 
          'enabled' => false,
          'amount' => 0.00
        }
      end

      def discount
        { 
          'enabled' => false,
          'pending' => false
        }
      end
    end
  end
end
