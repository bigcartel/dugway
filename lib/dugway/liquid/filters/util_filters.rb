module UtilFilters
private
  
  # Registered Vars
    
  def theme
    @context.registers[:theme]
  end
  
  def cart
    @context.registers[:cart]
  end
    
  def currency
    @context.registers[:currency]
  end
  
  def params
    @context.registers[:params]
  end
  
  # Mimics
  
  def number_with_delimiter(number, delimiter=",", separator=".")
    begin
      parts = number.to_s.split('.')
      parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
      parts.join separator
    rescue
      number
    end
  end

  def number_with_precision(number, precision=3)
    "%01.#{precision}f" % number
  rescue
    number
  end

  def tag(name, options = nil, open = false, escape = true)
    "<#{name}#{tag_options(options, escape) if options}" + (open ? ">" : " />")
  end
  
  def tag_options(options, escape = true)
    unless options.blank?
      attrs = []
      if escape
        options.each do |key, value|
          next unless value
          key = h(key.to_s)
          value = h(value)
          attrs << %(#{key}="#{value}")
        end
      else
        attrs = options.map { |key, value| %(#{key}="#{value}") }
      end
      " #{attrs.sort * ' '}" unless attrs.empty?
    end
  end
  
  def content_tag(type, content, options = {})
    result  = tag(type, options, true)
    result += content
    result += "</#{type}>"
  end
  
  def select_tag(name, option_tags = nil, options = {})
    content_tag :select, option_tags, { "name" => name, "id" => name }.update(options.stringify_keys)
  end
  
  def option_tag(name, value, selected=false)
    content_tag :option, name, { :value => value, :selected => selected ? 'selected' : nil }
  end
  
  def text_field_tag(name, value = nil, options = {})
    tag(:input, { "type" => "text", "name" => name, "id" => name, "value" => value }.update(options.stringify_keys))
  end

  def hidden_field_tag(name, value = nil, options = {})
    text_field_tag(name, value, options.stringify_keys.update("type" => "hidden"))
  end
  
  def text_area_tag(name, content = nil, options = {})
    options.stringify_keys!

    if size = options.delete("size")
      options["cols"], options["rows"] = size.split("x") if size.respond_to?(:split)
    end

    content_tag :textarea, content, { "name" => name, "id" => name }.update(options)
  end
  
  def radio_button_tag(name, value, checked = false, options = {})
    pretty_tag_value = value.to_s.gsub(/\s/, "_").gsub(/(?!-)\W/, "").downcase
    pretty_name = name.to_s.gsub(/\[/, "_").gsub(/\]/, "")
    html_options = { "type" => "radio", "name" => name, "id" => "#{pretty_name}_#{pretty_tag_value}", "value" => value }.update(options.stringify_keys)
    html_options["checked"] = "checked" if checked
    tag :input, html_options
  end
end
