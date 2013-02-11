class PaginatedProducts < Array
  attr_accessor :context
  
  def total_entries
    if context['internal']['total_entries'].blank?
      context['internal']['total_entries'] = size
    end
    
    context['internal']['total_entries']
  end
  
  def current_page
    if @current_page.blank?
      @current_page = if context['internal'].present? && context['internal'].has_key?('page') # has_key? here because 'page' will be nil for get blocks
        context['internal']['page'].to_i
      else
        context.registers[:params][:page].to_i
      end
    
      @current_page = 1 if @current_page.zero?
    end
    
    @current_page
  end
  
  def per_page
    if @per_page.blank?
      @per_page = if context['internal'].present?
        if context['internal']['per_page'].present?
          context['internal']['per_page']
        else
          context.registers[:settings][:products_per_page]
        end
      else
        100
      end
    
      @per_page = [100, @per_page.to_i].min
    end  
    
    @per_page
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
  
  def inner_window
    @inner_window ||= 3
  end
  
  def outer_window
    @outer_window ||= 1
  end
  
private

  def order
    if context['internal'].present?
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
    else
      'products.position'
    end
  end
  
  def limit
    limit = if @context['internal'].present? && @context['internal']['limit'].present?
      @context['internal']['limit']
    else
      nil
    end
    
    limit.present? ? [100, limit.to_i].min : limit
  end
  
  def log(msg)
    Titanium.API.debug(msg)
  end
end

class ProductsDrop < BaseDrop
  def all
    @all ||= paginate @source
  end
  
  def current
    @context.stack do
      products =  if artist.present?
                    @source.select { |p| p.artists.all.any? { |a| a[:permalink] == artist }}
                  elsif category.present?
                    @source.select { |p| p.categories.all.any? { |c| c[:permalink] == category }}
                  elsif search_terms.present?
                    @source.select { |p| p[:name].downcase.include? search_terms.downcase }
                  else
                    @source
                  end
    
      paginate products
    end
  end
  
  def on_sale
    paginate @source.select { |p| p[:on_sale] }
  end
  
  
  #
  # Aliases
  #
  
  def newest
    all
  end
  
  def top_selling
    all
  end
  
  
  #
  # DEPRECATED
  #
  
  def featured
    all
  end
  

private

  def paginate(array)
    products = PaginatedProducts.new array
    products.context = @context
    
    log " "
    log "!!!!! PAGINATE !!!!!"
    log "products.total_entries: #{ products.total_entries }"
    log "products.per_page: #{ products.per_page }"
    log "products.current_page: #{ products.current_page }"
    log "products.previous_page: #{ products.previous_page }"
    log "products.next_page: #{ products.next_page }"
    log "products.total_pages: #{ products.total_pages }"
    log "products.offset: #{ products.offset }"
    log " "
    
    products[products.offset, products.per_page]
  end
  
  def artist
    @artist ||= @context.registers[:artist].permalink rescue nil
  end
  
  def category
    @category ||= @context.registers[:category].permalink rescue nil
  end

  def search_terms
    @context.registers[:params][:search]
  end  
end
