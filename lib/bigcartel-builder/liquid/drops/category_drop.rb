class CategoryDrop < BaseDrop    
  def products
    @products ||= liquify(*@source.products)
  end  
end
