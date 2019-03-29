module Dugway
  module Drops
    class OptionGroupOptionsDrop < BaseDrop
      def id
        source[:id]
      end

      def name
        source[:name]
      end

      def value
        source[:value]
      end
    end
  end
end
