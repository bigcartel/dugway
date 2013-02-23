module Dugway
  module Drops
    class CartDrop < BaseDrop
      def total
        0.00
      end

      def item_count
        0
      end

      def items
        []
      end

      def country
        nil
      end

      def shipping
        { 
          'enabled' => false,
          'amout' => 0.00,
          'strict' => false,
          'pending' => false
        }
      end

      def tax
        { 
          'enabled' => false,
          'amout' => 0.00
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
