class CartItemDrop < BaseDrop    
  def product
    @product ||= @source.product.to_liquid
  end
  
  def option
    @option ||= @source.product_option.to_liquid
  end  
end
