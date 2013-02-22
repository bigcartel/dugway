class PagesDrop < BaseDrop
  def all
    @all ||= source.select { |page| page['category'] == 'custom' }
  end  
end
