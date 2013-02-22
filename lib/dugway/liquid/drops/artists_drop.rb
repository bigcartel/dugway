class ArtistsDrop < BaseDrop
  def all
    @all ||= source
  end
  
  def active
    @active ||= source.reject { |a| store.artist_products(a['permalink']).empty? }
  end
end
