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
        elsif ActiveSupport.const_defined?(:Inflector)
          ActiveSupport::Inflector.pluralize(singular)
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

      def money(amount, format = nil)
        case format
        when 'sign' then money_with_sign(amount)
        when 'code' then money_with_code(amount)
        when 'sign_and_code' then money_with_sign_and_code(amount)
        else number_to_currency(amount, :unit => '').strip
        end
      end

      def money_with_sign(amount)
        unit = I18n.translate('number.currency.format.unit')
        number_to_currency(amount).gsub(unit, %{<span class="currency_sign">#{ HTMLEntities.new.encode(unit, :named) }</span>})
      end

      def money_with_code(amount)
        %{#{ money(amount) } <span class="currency_code">#{ currency['code'] }</span>}
      end

      def money_with_sign_and_code(amount)
        %{#{ money_with_sign(amount) } <span class="currency_code">#{ currency['code'] }</span>}
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
        options = options.present? ? options : []
        option_tags = options.inject('') { |t,o| t += option_tag((o['name'] + (o['has_custom_price'] ? " - #{ money_with_sign(o['price']) }" : '')), o['id']) }
        select_tag('cart[add][id]', option_tags, { :id => id, :class => class_name })
      end

      def options_radio(options, id = 'option', class_name = nil)
        list = ''

        for o in options
          list += '<li>'
          list += radio_button_tag('cart[add][id]', o['id'], o['default'], { :id => "option_#{o['id']}", :class => class_name })
          list += %{ <label for="option_#{o['id']}">#{o['name']}}
          list += %{ - #{ money_with_sign(o['price']) }} if o['has_custom_price']
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
        divider = '------------'
        countries = [label, divider, country['name'], divider, 'Aland Islands', 'Afghanistan', 'Albania', 'Algeria', 'American Samoa', 'Andorra', 'Angola', 'Anguilla', 'Antarctica', 'Antigua And Barbuda', 'Argentina', 'Armenia', 'Aruba', 'Australia', 'Austria', 'Azerbaijan', 'Bahamas', 'Bahrain', 'Bangladesh', 'Barbados', 'Belarus', 'Belgium', 'Belize', 'Benin', 'Bermuda', 'Bhutan', 'Bolivia', 'Bosnia and Herzegovina', 'Botswana', 'Bouvet Island', 'Brazil', 'British Indian Ocean Territory', 'British Virgin Islands', 'Brunei Darussalam', 'Bulgaria', 'Burkina Faso', 'Burundi', 'Cambodia', 'Cameroon', 'Canada', 'Cape Verde', 'Cayman Islands', 'Central African Republic', 'Chad', 'Chile', 'China', 'Christmas Island', 'Cocos (Keeling) Islands', 'Colombia', 'Comoros', 'Congo', 'Cook Islands', 'Costa Rica', 'Croatia (Hrvatska)', 'Cuba', 'Cyprus', 'Czech Republic', 'Democratic Republic of the Congo', 'Denmark', 'Djibouti', 'Dominica', 'Dominican Republic', 'East Timor', 'Ecuador', 'Egypt', 'El Salvador', 'Equatorial Guinea', 'Eritrea', 'Estonia', 'Ethiopia', 'Falkland Islands (Malvinas)', 'Faroe Islands', 'Fiji', 'Finland', 'France', 'France, Metropolitan', 'French Guiana', 'French Polynesia', 'French Southern Territories', 'Gabon', 'Gambia', 'Georgia', 'Germany', 'Ghana', 'Gibraltar', 'Greece', 'Greenland', 'Grenada', 'Guadeloupe', 'Guam', 'Guatemala', 'Guernsey', 'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti', 'Heard and McDonald Islands', 'Honduras', 'Hong Kong', 'Hungary', 'Iceland', 'India', 'Indonesia', 'Iran', 'Iraq', 'Ireland', 'Isle of Man', 'Israel', 'Italy', 'Jamaica', 'Japan', 'Jersey', 'Jordan', 'Kazakhstan', 'Kenya', 'Kiribati', 'Kuwait', 'Kyrgyzstan (Kyrgyz Republic)', 'Laos', 'Latvia', 'Lebanon', 'Lesotho', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Macau', 'Macedonia', 'Madagascar', 'Malaysia', 'Maldives', 'Mali', 'Malta', 'Marshall Islands', 'Martinique', 'Mauritania', 'Mauritius', 'Mayotte', 'Mexico', 'Micronesia', 'Moldova', 'Monaco', 'Mongolia', 'Montserrat', 'Morocco', 'Mozambique', 'Myanmar', 'Namibia', 'Nauru', 'Nepal', 'Netherlands', 'Netherlands Antilles', 'Neutral Zone (Saudia Arabia/Iraq)', 'New Caledonia', 'New Zealand', 'Nicaragua', 'Niger', 'Nigeria', 'Niue', 'Norfolk Island', 'Northern Mariana Islands', 'Norway', 'Oman', 'Pakistan', 'Palau', 'Palestine', 'Panama', 'Papua New Guinea', 'Paraguay', 'Peru', 'Philippines', 'Pitcairn', 'Poland', 'Portugal', 'Puerto Rico', 'Qatar', 'Reunion', 'Romania', 'Russian Federation', 'Rwanda', 'S. Georgia and S. Sandwich Isls.', 'Saint Kitts and Nevis', 'Saint Lucia', 'Saint Vincent and The Grenadines', 'Samoa', 'San Marino', 'Sao Tome and Principe', 'Saudi Arabia', 'Senegal', 'Seychelles', 'Sierra Leone', 'Singapore', 'Slovakia (Slovak Republic)', 'Slovenia', 'Solomon Islands', 'Somalia', 'South Africa', 'South Korea', 'Soviet Union (former)', 'Spain', 'Sri Lanka', 'St. Helena', 'St. Pierre and Miquelon', 'Sudan', 'Suriname', 'Svalbard and Jan Mayen Islands', 'Swaziland', 'Sweden', 'Switzerland', 'Syria', 'Taiwan', 'Tajikistan', 'Tanzania', 'Thailand', 'Timore-Leste', 'Togo', 'Tokelau', 'Tonga', 'Trinidad and Tobago', 'Tunisia', 'Turkey', 'Turkmenistan', 'Turks and Caicos Islands', 'Tuvalu', 'Uganda', 'Ukraine', 'United Arab Emirates', 'United Kingdom', 'United States', 'United States Minor Outlying Islands', 'Uruguay', 'Uzbekistan', 'Vanuatu', 'Vatican City State (Holy See)', 'Venezuela', 'Viet Nam', 'Virgin Islands (US)', 'Wallis and Futuna Islands', 'Western Sahara', 'Yemen', 'Yugoslavia', 'Zaire', 'Zambia', 'Zimbabwe']

        options = countries.inject('') do |t, c|
          v = c == label || c == divider ? '' : Digest::SHA1.hexdigest(c) # give it a random ID that'll be consistent
          t += option_tag(c, v)
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
          text_area_tag(field, contact['message'], :id => id, :class => class_name)
        when 'captcha'
          text_field_tag('captcha', '', :id => id, :class => class_name)
        else
          text_field_tag(field, contact[field], :id => id, :class => class_name)
        end
      end
    end
  end
end
