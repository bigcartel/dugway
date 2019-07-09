module Dugway
  module Drops
    class OptionGroupValueDrop < BaseDrop

      def id
        source['id']
      end

      def name
        source['name']
      end

      def position
        source['position']
      end

      def option_group_id
        source['option_group_id']
      end

    end
  end
end
