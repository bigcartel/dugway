module Dugway
  module Drops
    class OptionGroupDrop < BaseDrop

      def name
        source[:name]
      end

      def position
        source[:position]
      end

      def values
        source[:values]
      end

    end
  end
end
