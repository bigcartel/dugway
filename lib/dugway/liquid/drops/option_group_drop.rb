module Dugway
  module Drops
    class OptionGroupDrop < BaseDrop

      def id
        source['id']
      end

      def name
        source['name']
      end

      def position
        source['position']
      end

      def values
        @values ||= source['values'].present? ?
          source['values'].map { |value| OptionGroupValueDrop.new(value) } : []
      end

    end
  end
end
