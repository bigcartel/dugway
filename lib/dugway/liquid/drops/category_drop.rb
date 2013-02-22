class CategoryDrop < BaseDrop
  def products
    @store.category_products(permalink)
  end
end
