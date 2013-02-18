class PaginatedProducts < Array
  attr_accessor :context
  
  def total_entries
    @total_entries ||= context['internal']['total_entries'] = size
  end
  
  def current_page
    @current_page ||= context.registers[:params][:page].to_i rescue 1
  end
  
  def per_page
    @per_page ||= context['internal']['per_page']
  end
  
  def offset
    @offset ||= (current_page - 1) * per_page
  end
  
  def total_pages
    @total_pages ||= (total_entries.to_f / per_page.to_f).ceil.to_i
  end
  
  def previous_page
    @previous_page ||= current_page <= 1 ? nil : current_page - 1
  end
  
  def next_page
    @next_page ||= current_page >= total_pages ? nil : current_page + 1
  end
  
  # TODO: support this
  def inner_window
    @inner_window ||= 3
  end
  
  # TODO: support this
  def outer_window
    @outer_window ||= 1
  end
  
  private
  
  def order
    @order ||= begin
      case context['internal']['order']
      when 'newest'
        'created_at DESC'
      when 'sales'
        'sales'
      when 'views'
        'products.views DESC'
      else
        'products.position'
      end
    end
  end
  
  def limit
    @limit ||= @context['internal']['limit'] || 100
  end
end

class ProductsDrop < BaseDrop
  def all
    @all ||= paginate @source
  end
  
  def current
    @current ||= paginate begin
      if artist.present?
        @source.select { |p| p.artists.all.any? { |a| a['permalink'] == artist }}
      elsif category.present?
        @source.select { |p| p.categories.all.any? { |c| c['permalink'] == category }}
      elsif search_terms.present?
        @source.select { |p| p['name'].downcase.include? search_terms.downcase }
      else
        @source
      end
    end
  end
  
  def on_sale
    @on_sale ||= paginate @source.select { |p| p[:on_sale] }
  end
  
  def newest
    all
  end
  
  def top_selling
    all
  end

  private

  def paginate(array)
    products = PaginatedProducts.new array
    products.context = @context
    products[products.offset, products.per_page]
  end
  
  def artist
    @artist ||= @context.registers[:artist].permalink rescue nil
  end
  
  def category
    @category ||= @context.registers[:category].permalink rescue nil
  end

  def search_terms
    @search_terms ||= @context.registers[:params][:search]
  end  
end
