class ThemeDrop < BaseDrop  
  def image
    nil
  end
  
  # TODO: look into why we didn't just name the variable featured_limit
  def featured_limit
    @source.featured_products
  end
end
