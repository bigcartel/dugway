class ArtistsDrop < BaseDrop
  def all
    @all ||= @source
  end

  def active
    all
  end
end
