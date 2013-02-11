class AccountDrop < BaseDrop  
	def logged_in
		@logged_in
	end

  def currency
    @currency ||= CurrencyDrop.new(@source.currency)
  end
  
  def country
    @country ||= CountryDrop.new(@source.country)
  end  
end
