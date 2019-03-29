module Dugway
  module Drops
    class VariantDrop < BaseDrop

      def id
        source[:id]
      end

      def name
        source[:name]
      end

      def option1
        source[:option1]
      end

      def option2
        source[:option2]
      end

      def option3
        source[:option3]
      end

      def price
        source[:price]
      end

      def quantity
        source[:quantity]
      end

    end
  end
end
