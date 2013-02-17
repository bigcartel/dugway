class PagesDrop < BaseDrop
  def permalink_lookup
    @source
  end
  
  def all
    @all ||= @source.find_all { |page| page['category'] == 'custom' }
  end  
end
