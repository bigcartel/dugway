module Dugway
  module Drops
    class CategoriesDrop < BaseDrop
      def all
        @all ||= source
      end

      def active
        @active ||= source.reject { |c| store.category_products(c['permalink']).empty? }
      end
    end
  end
end
