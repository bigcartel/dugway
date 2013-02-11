class Paginate < ::Liquid::Block
  Syntax = /(\w+)\s+from\s+(#{ Liquid::QuotedFragment })\s*(by\s*(#{ Liquid::QuotedFragment }))?/

  def initialize(tag_name, markup, tokens)
    if markup =~ Syntax
      @variable_name = $1
      @collection_name = $2
      @per_page = $3.present? ? $4 : nil
      
      @attributes = { 'inner_window' => 3, 'outer_window' => 1 }

      markup.scan(Liquid::TagAttributes) { |key, value|
        @attributes[key] = value
      }
      
      @limit = @attributes['limit']
    else
      raise SyntaxError.new("Syntax Error in tag 'paginate' - Valid syntax: paginate [variable] from [collection] by [number]")
    end

    super
  end

  def render(context)
    @context = context
    @limit = context[@limit].present? ? context[@limit] : (@limit.present? ? @limit.to_i : nil)
    @per_page = context[@per_page].present? ? context[@per_page] : (@per_page.present? ? @per_page.to_i : nil)
    @order = context[@attributes['order']].present? ? context[@attributes['order']] : @attributes['order']

    context.stack do
      context['internal'] = {
        'per_page' => @per_page,
        'order' => @order,
        'page' => @context.registers[:params][:page],
        'limit' => @limit
      }
      
      collection = context[@collection_name]
      context[@variable_name] = collection
      current_page = collection.current_page

      pagination = {
        'page_size' => collection.per_page,
        'current_page' => current_page,
        'current_offset' => collection.offset
      }

      context['paginate'] = pagination

      collection_size = collection.total_entries

      raise ArgumentError.new("Cannot paginate array '#{ @collection_name }'. Not found.")  if collection_size.nil?

      page_count = collection.total_pages

      pagination['items'] = collection_size
      pagination['pages'] = page_count
      pagination['previous'] = collection.previous_page.blank? ? no_link('&laquo; Previous') : link('&laquo; Previous', collection.previous_page)
      pagination['next'] = collection.next_page.blank? ? no_link('Next &raquo;') : link('Next &raquo;', collection.next_page)
      pagination['parts'] = []

      if page_count > 1
        inner_window = @attributes['inner_window'].to_i
        outer_window = @attributes['outer_window'].to_i
        
        min = current_page - inner_window
        max = current_page + inner_window

        # Adjust lower or upper limit if other is out of bounds
        if max > page_count
          min -= max - page_count
        elsif min < 1
          max += 1 - min
        end

        current = min..max
        beginning = 1..(1 + outer_window)
        tail = (page_count - outer_window)..page_count
        visible = [current, beginning, tail].map(&:to_a).flatten
        visible &= (1..page_count).to_a

        hellip_break = false

        1.upto(page_count) { |page|
          if page == current_page
            pagination['parts'] << no_link(page)
          elsif visible.include?(page)
            pagination['parts'] << link(page, page)
          elsif page == beginning.last + 1 || page == tail.first - 1
            next  if hellip_break

            pagination['parts'] << no_link('&hellip;')
            hellip_break = true
            next
          end

          hellip_break = false
        }
      end

      render_all @nodelist, context
    end
  end


private

  def no_link(title)
    { 'title' => title.to_s, 'is_link' => false }
  end

  def link(title, page)
    { 'title' => title.to_s, 'url' => current_url + "?page=#{ page }#{ search }", 'is_link' => true }
  end

  def search
    @context.registers[:params]['search'].present? ? "&search=#{ @context.registers[:params]['search'] }" : nil
  end

  def current_url
    @context.registers[:path]
  end
  
  def log(msg)
    Titanium.API.debug(msg)
  end
end