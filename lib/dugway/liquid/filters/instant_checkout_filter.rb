module Dugway
  module Filters
    module InstantCheckoutFilter
      DIV_STYLES = [
        "border-radius: 4px",
        "font-size: 20px",
        "font-weight: bold"
      ].freeze

      LINK_STYLES = [
        "border-radius: 4px",
        "height: 100%",
        "display: flex",
        "padding: 10px",
        "align-items: center",
        "justify-content: center"
      ].freeze

      def instant_checkout_button(account, a=nil, b=nil)
        account = @context.registers[:account]
        theme, height = sanitize_options(a, b)

        return nil unless account.instant_checkout?

        div_styles = generate_div_styles(theme, height)
        link_styles = generate_link_styles(theme)

        %(<div id="instant-checkout-button" style="#{ div_styles }"><a href="https://www.bigcartel.com/resources/help/article/apple-pay" style="#{ link_styles }">Instant Checkout</a></div>)
      end

      private

      def sanitize_options(a, b)
        theme = height = nil

        [a, b].each do |value|
          theme = value if /\A(dark|light(?:-outline)?)\z/.match(value)
          height = value if /\A\d+(px|em|\%)\z/.match(value)
        end

        return theme, height
      end

      def generate_div_styles(theme, height)
        styles = DIV_STYLES.dup
        styles << "border: 1px solid black" if theme == "light-outline"
        styles << "height: #{ height }" if height
        styles << colors(theme)
        styles.join("; ")
      end

      def generate_link_styles(theme)
        styles = LINK_STYLES.dup
        styles << colors(theme)
        styles.join("; ")
      end

      def colors(theme)
        if theme =~ /\Alight/
          "background-color: white; color: black"
        else
          "background-color: black; color: white"
        end
      end
    end
  end
end