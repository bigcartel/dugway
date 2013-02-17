class AccountDrop < BaseDrop
  def logged_in
    false
  end

  def currency
    @currency ||= CurrencyDrop.new(@source['currency'])
  end
  
  def country
    @country ||= CountryDrop.new(@source['country'])
  end  
end
