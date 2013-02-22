module Dugway
  module Drops
    class ArtistDrop < BaseDrop
      def products
        store.artist_products(permalink).map { |p| ProductDrop.new(p) }
      end
    end
  end
end
