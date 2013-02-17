class Get < ::Liquid::Block
  Syntax = /((#{ Liquid::QuotedFragment })\s+)?(\w+)\s+from\s+(#{ Liquid::QuotedFragment }+)/
  
  def initialize(tag_name, markup, tokens)
    if markup =~ Syntax
      @number_to_get = $1.present? ? $2 : nil
      @variable_name = $3
      @collection_name = $4

      @attributes = {}
      markup.scan(Liquid::TagAttributes) { |key, value|
        @attributes[key] = value
      }
    else
      raise SyntaxError.new("Syntax Error in tag 'get' - Valid syntax: get [number] [items] from [collection] order:[order]")
    end

    super
  end

  def render(context)
    @context = context
    
    @number_to_get = if context[@number_to_get].present?
      context[@number_to_get]
    elsif @number_to_get.present?
      @number_to_get.to_i
    elsif @attributes['limit'].present?
      if context[@attributes['limit']].present?
        context[@attributes['limit']]
      else
        @attributes['limit'].to_i
      end
    else
      nil
    end
    
    @order = context[@attributes['order']].present? ? context[@attributes['order']] : @attributes['order']
    
    context.stack do
      context['internal'] = {
        'per_page' => @number_to_get,
        'order' => @order,
        'page' => nil
      }
      
      context[@variable_name] = context[@collection_name]

      raise ArgumentError.new("Cannot get array '#{ @collection_name }'. Not found.")  if context[@variable_name].total_entries.nil?

      render_all @nodelist, context
    end
  end
end