module Dugway
  module Filters
    module UtilFilters
      private

      # Registered Vars

      def currency
        @context.registers[:currency]
      end

      # Mimics

      DEFAULT_CURRENCY_VALUES = { :format => "%u%n", :negative_format => "-%u%n", :unit => "$", :separator => ".", :delimiter => ",", :precision => 2, :significant => false, :strip_insignificant_zeros => false }

      def number_to_currency(number, options={})
        return unless number

        options.symbolize_keys!

        defaults  = I18n.translate(:'number.format', :locale => options[:locale], :default => {})
        currency  = I18n.translate(:'number.currency.format', :locale => options[:locale], :default => {})
        currency[:negative_format] ||= "-" + currency[:format] if currency[:format]

        defaults  = DEFAULT_CURRENCY_VALUES.merge(defaults).merge!(currency)
        defaults[:negative_format] = "-" + options[:format] if options[:format]
        options   = defaults.merge!(options)

        unit      = options.delete(:unit)
        format    = options.delete(:format)

        if number.to_f < 0
          format = options.delete(:negative_format)
          number = number.respond_to?("abs") ? number.abs : number.sub(/^-/, '')
        end

        value = number_with_precision(number, options)
        format.gsub(/%n/, value).gsub(/%u/, unit)
      end

      def number_with_delimiter(number, options={})
        options.symbolize_keys!

        begin
          Float(number)
        rescue ArgumentError, TypeError
          if options[:raise]
            raise InvalidNumberError, number
          else
            return number
          end
        end

        defaults = I18n.translate(:'number.format', :locale => options[:locale], :default => {})
        options = options.reverse_merge(defaults)

        parts = number.to_s.to_str.split('.')
        parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")
        parts.join(options[:separator]).html_safe
      end

      def number_with_precision(number, options={})
        options.symbolize_keys!

        number = begin
          Float(number)
        rescue ArgumentError, TypeError
          if options[:raise]
            raise InvalidNumberError, number
          else
            return number
          end
        end

        defaults           = I18n.translate(:'number.format', :locale => options[:locale], :default => {})
        precision_defaults = I18n.translate(:'number.precision.format', :locale => options[:locale], :default => {})
        defaults           = defaults.merge(precision_defaults)

        options = options.reverse_merge(defaults)  # Allow the user to unset default values: Eg.: :significant => false
        precision = options.delete :precision
        significant = options.delete :significant
        strip_insignificant_zeros = options.delete :strip_insignificant_zeros

        if significant and precision > 0
          if number == 0
            digits, rounded_number = 1, 0
          else
            digits = (Math.log10(number.abs) + 1).floor
            rounded_number = (BigDecimal(number.to_s) / BigDecimal((10 ** (digits - precision)).to_f.to_s)).round.to_f * 10 ** (digits - precision)
            digits = (Math.log10(rounded_number.abs) + 1).floor # After rounding, the number of digits may have changed
          end
          precision -= digits
          precision = precision > 0 ? precision : 0  #don't let it be negative
        else
          rounded_number = BigDecimal(number.to_s).round(precision).to_f
        end
        formatted_number = number_with_delimiter("%01.#{precision}f" % rounded_number, options)
        if strip_insignificant_zeros
          escaped_separator = Regexp.escape(options[:separator])
          formatted_number.sub(/(#{escaped_separator})(\d*[1-9])?0+\z/, '\1\2').sub(/#{escaped_separator}\z/, '').html_safe
        else
          formatted_number
        end
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
  end
end
