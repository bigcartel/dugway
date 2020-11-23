module Dugway
  module Drops
    class PagesDrop < BaseDrop
      def all
        @all ||= source.select { |page| page['category'] == 'custom' }
      end

      def cart
        @cart ||= source.find { |page| page['permalink'] == 'cart' }
      end
    end
  end
end
