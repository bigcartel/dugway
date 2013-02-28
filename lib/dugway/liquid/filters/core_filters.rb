require 'htmlentities'

module Dugway
  module Filters
    module CoreFilters
      # Text Filters

      def pluralize(count, singular, plural = nil)
        "#{count} " + if count == 1
          singular
        elsif plural
          plural
        else
          singular + "s"
        end
      end

      def paragraphs(text)
        tags   = '(table|thead|tfoot|caption|colgroup|tbody|tr|td|th|div|dl|dd|dt|ul|ol|li|pre|select|form|map|area|blockquote|address|math|style|input|p|h[1-6]|hr|script|embed|object|param|code|center|dir|fieldset|menu|noframes|noscript|frameset|applet|button|del|iframe|ins)' 
        text   = text.to_s.gsub(/\r\n?/, "\n") # \r\n and \r -> \n          
        blocks = text.split(/\n\n+/) # split on double newlines
        blocks.inject('') do | result, block |
          block.strip!
          if block =~ /<\s*(\/)?\s*#{tags}\s*(\/)?\s*>.*(<\s*\/\s*\1\s*>)?/i
            result << block
          else
            block.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />')  # 1 newline -> br
            result << "<p>#{block}</p>"
          end
          result << "\n"
        end
      end

      # Money Filters

      def money(amount)
        number_to_currency(amount, :locale => nil, :precision => I18n.translate('number.currency.format.precision'), :unit => '', :separator => I18n.translate('number.currency.format.separator'), :delimiter => I18n.translate('number.currency.format.delimiter'), :format => I18n.translate('number.currency.format.format')).strip
      end

      def money_with_sign(amount)
        unit = I18n.translate('number.currency.format.unit')
        number_to_currency(amount).try(:gsub, unit, "<span class=\"currency_sign\">#{ HTMLEntities.new.encode(unit, :named) }</span>")
      end

      def money_with_code(amount)
        %{#{ money(amount) } <span class="currency_code">#{ currency.code }</span>}
      end

      def money_with_sign_and_code(amount)
        %{#{ money_with_sign(amount) } <span class="currency_code\">#{ currency.code }</span>}
      end

      # Shipping Filters

      def shipping_name(area, everywhere = 'Everywhere', everywhere_else = 'Everywhere else')
        if area.country.name.present?
          area.country['name']
        elsif area.strict
          everywhere_else
        else
          everywhere
        end
      end

      # Input Filters

      def hidden_option_input(option, id = 'option', class_name = nil)
        hidden_field_tag('cart[add][id]', option['id'], { :id => id, :class => class_name })
      end

      def options_select(options, id = 'option', class_name = nil)
        option_tags = options.inject('') { |t,o| t += option_tag((o['name'] + (o['has_custom_price'] ? " - #{ currency['sign'] }#{ money(o['price']) }" : '')), o['id']) }
        select_tag('cart[add][id]', option_tags, { :id => id, :class => class_name })
      end

      def options_radio(options, id = 'option', class_name = nil)
        list    = ''
        for o in options
          list += '<li>'
          list += radio_button_tag('cart[add][id]', o['id'], o['default'], { :id => "option_#{ o['id'] }", :class => class_name })
          list += %{ <label for="option_#{ o['id'] }">#{ o['name'] }}
          list += %{ - #{ currency['sign'] }#{ money(o['price']) }} if o['has_custom_price']
          list += %{</label>}
          list += '</li>'
        end
        %{<ul id="#{id}">#{list}</ul>}
      end

      def product_quantity_input(product, quantity = 1, id = nil, class_name = nil)
        text_field_tag("cart[add][quantity]", quantity, { :id => id || "quantity_#{product['id']}", :class => class_name, :autocomplete => 'off' })
      end

      def item_quantity_input(item, id = nil, class_name = nil)
        text_field_tag("cart[update][#{ item['id'] }]", item['quantity'], { :id => id || "item_#{ item['id'] }_qty", :class => class_name, :autocomplete => 'off' })
      end

      def country_select(country, label = 'Select your country...', id = 'country', class_name = nil)
        found     = false
        countries = [[label, ''], ['------------',''], [country['name'], country['id']], ['------------','']] + Country.options
        options   = countries.inject('') do |t,c|
          select  = !found && c[1] == cart.country_id
          found   = true if select
          t += option_tag(c[0], c[1], select)
        end
        select_tag('cart[country_id]', options, { :id => id, :class => class_name })
      end

      def discount_code_input(discount, id = 'cart_discount_code', class_name = nil)
        text_field_tag('cart[discount_code]', nil, { :id => id, :class => class_name, :autocomplete => 'off' })
      end

      # Contact Filters

      def contact_input(contact, field, id = nil, class_name = nil)
        field = field.downcase
        id    ||= field
        case field
        when 'message'
          text_area_tag(field, contact['message'], :id => id, :class => class_name, :tabindex => contact_tab_index)
        when 'captcha'
          text_field_tag('captcha', '', :id => id, :class => class_name, :tabindex => contact_tab_index)
        else
          text_field_tag(field, contact[field], :id => id, :class => class_name, :tabindex => contact_tab_index)
        end
      end

      private

      def contact_tab_index
        @contact_tab_index ||= 0
        @contact_tab_index += 1
      end  
    end
  end
end
