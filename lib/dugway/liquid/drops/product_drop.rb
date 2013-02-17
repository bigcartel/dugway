class ProductDrop < BaseDrop
  def css_class
    c = 'product'
    c += ' sold' if status == 'sold-out'
    c += ' soon' if status == 'coming-soon'
    c += ' sale' if on_sale
    c
  end
  
  def status
    @source['status']
  end
  
  def on_sale
    @source['on_sale']
  end
  
  def min_price
    price_min_max.first
  end

  def max_price
    price_min_max.last
  end

  def variable_pricing
    min_price != max_price
  end
  
  def has_default_option
    @has_default_option ||= option.present?
  end
  
  def option
    @option ||= options.blank? ? nil : options[0]
  end
  
  def options
    @options ||= @source['options'].map { |o| ProductOptionDrop.new(o) }
  end
  
  def options_in_stock
    @options_in_stock ||= @source['options'].map { |o| ProductOptionDrop.new(o) }
  end
  
  def shipping
    @shipping ||= @source['shipping'].map { |o| ShippingOptionDrop.new(o) }
  end
  
  def image
    @image ||= images.blank? ? nil : images[0]
  end
  
  def images
    @images ||= @source['images'].map { |i| ImageDrop.new(i) }
  end
  
  def image_count
    @image_count ||= images.size
  end

  def previous_product
    @previous_product ||= @source['higher_item'] || ''
  end
  
  def next_product
    @next_product ||= @source['lower_item'] || ''
  end

  def edit_url
    "http://bigcartel.com"
  end

  def categories
    @categories ||= CategoriesDrop.new(@source['categories'].map { |c| CategoryDrop.new(c) })
  end

  def artists
    @artists ||= ArtistsDrop.new(@source['artists'].map { |a| ArtistDrop.new(a) })
  end

private
  
  def price_min_max
    @price_min_max ||= options.collect(&:price).uniq.minmax
  end
end
