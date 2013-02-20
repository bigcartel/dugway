require 'will_paginate/array'

class ProductsDrop < BaseDrop
  def all
    sort_and_paginate @source
  end
  
  def current
    sort_and_paginate begin
      if artist.present?
        @source.select { |p| p['artists'].all.any? { |a| a['permalink'] == artist }}
      elsif category.present?
        @source.select { |p| p['categories'].all.any? { |c| c['permalink'] == category }}
      elsif search_terms.present?
        @source.select { |p| p['name'].downcase.include? search_terms.downcase }
      else
        @source
      end
    end
  end
  
  def on_sale
    sort_and_paginate @source.select { |p| p['on_sale'] }
  end

  private
  
  def order
    begin case @context['internal']['order']
      when 'newest', 'date'
        'date'
      # We don't pass these in the API, so fake it
      when 'sales', 'sells', 'views'
        'shuffle'
      else
        'position'
      end
    end
  end

  def sort_and_paginate(array)
    if order == 'shuffle'
      array.shuffle!
    elsif order == 'date'
      array.sort! { |a,b| b['id'] <=> a['id'] }
    else
      array.sort_by! { |p| p[order] }
    end
    
    array.paginate({
      :page => (@context.registers[:params][:page] || 1).to_i,
      :per_page => @context['internal']['per_page']
    })
  end
  
  def artist
    @context.registers[:artist]['permalink'] rescue nil
  end
  
  def category
    @context.registers[:category]['permalink'] rescue nil
  end

  def search_terms
    @context.registers[:params][:search]
  end  
end
