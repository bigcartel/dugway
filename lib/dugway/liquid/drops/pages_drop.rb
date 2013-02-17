class PagesDrop < BaseDrop
  def all
    @all ||= @source.find_all { |page| page['category'] == 'custom' }
  end  
end
