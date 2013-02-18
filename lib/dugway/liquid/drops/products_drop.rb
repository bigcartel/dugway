require 'will_paginate/array'

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
    array.paginate({
      :page => (@context.registers[:params][:page] || 1).to_i,
      :per_page => @context['internal']['per_page']
    })
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
