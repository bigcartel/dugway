class ShippingOptionDrop < BaseDrop  
  def country
    @country ||= CountryDrop.new(@source.country)
  end  
end
