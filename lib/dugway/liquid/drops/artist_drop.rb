class ArtistDrop < BaseDrop
  def products
    @store.artist_products(permalink)
  end
end
