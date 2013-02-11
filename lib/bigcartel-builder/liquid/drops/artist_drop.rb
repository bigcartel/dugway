class ArtistDrop < BaseDrop    
	def products
  	@products ||= liquify(*@source.products)
  end  
end
