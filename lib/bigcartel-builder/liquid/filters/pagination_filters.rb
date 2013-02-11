# This is basically a duplication of an older will_paginate plugin

module PaginationFilters  
  def paginate(entries, id = 'pagination', class_name = 'pagination', previous_label = '&laquo; Previous', next_label = 'Next &raquo;', inner_window = 4, outer_window = 1, separator = ' ')
    options     = { :class => class_name, :previous_label => previous_label, :next_label => next_label, :inner_window => inner_window, :outer_window => outer_window, :separator => separator }    
    total_pages = entries.total_pages

    if total_pages > 1
      
      page    = entries.current_page
      options = { :id => id, :class => class_name, :previous_label => previous_label, :next_label => next_label, :inner_window => inner_window, :outer_window => outer_window, :separator => separator }
      inner_window, outer_window = options.delete(:inner_window).to_i, options.delete(:outer_window).to_i
      min = page - inner_window
      max = page + inner_window

      # adjust lower or upper limit if other is out of bounds
      if max > total_pages then min -= max - total_pages
      elsif min < 1  then max += 1 - min
      end
      
      current   = min..max
      beginning = 1..(1 + outer_window)
      tail      = (total_pages - outer_window)..total_pages
      visible   = [current, beginning, tail].map(&:to_a).flatten
      visible  &= (1..total_pages).to_a
      
      # build the list of the links
      links = (1..total_pages).inject([]) do |list, n|
        if visible.include? n
          list << page_link_or_span((n != page ? n : nil), 'current', n)
        elsif n == beginning.last + 1 || n == tail.first - 1
          list << '<span class="gap">...</span>'
        end
        list
      end
      
      # next and previous buttons
      links.unshift page_link_or_span(entries.previous_page, 'disabled', options.delete(:previous_label))
      links.push    page_link_or_span(entries.next_page,     'disabled', options.delete(:next_label))
      
      content_tag :div, links.join(options.delete(:separator)), options
    end
    
  end
  
private
  
  def page_link_or_span(page, span_class, text = page.to_s)
    unless page
      span_class.blank? ? %{<span>#{text}</span>} : %{<span class="#{span_class}">#{text}</span>}
    else
      link = "<a href=\""
      if params[:category]
        link += "/category/#{params[:category]}"
      elsif params[:artist]
        link += "/artist/#{params[:artist]}"
      elsif params[:search]
        link += "/products?search=#{params[:search]}"
      else
        link += "/products"
      end
      link += "#{link.include?('?') ? '&' : '?'}page=#{page}" if page > 1
      link += "\">#{text}</a>"
      link
    end
  end  
end
