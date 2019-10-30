module Dugway
  module Filters
    module InstantCheckoutFilter
      def instant_checkout_button(account, a=nil, b=nil)
        account = @context.registers[:account]
        theme, height = sanitize_options(a, b)

        return nil unless account.using_stripe?

        div_styles = generate_div_styles(theme, height)
        anchor_styles = generate_anchor_styles(theme)

        %(<div id="instant-checkout-button" style="#{ div_styles }"><a href="https://help.bigcartel.com/instant-checkout" target="_new" style="#{ anchor_styles }">Instant Checkout</a></div>)
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

      private

      def generate_div_styles(theme, height)
        styles = [
          "border-radius: 3px",
          "padding: 10px",
          "font-size: 20px",
          "font-weight: bold",
          colors(theme)
        ]

        styles << "border: 1px solid black" if theme == "light-outline"
        styles << "height: #{ height }" if height

        styles.join("; ")
      end

      def generate_anchor_styles(theme)
        [
          "height: 100%",
          "display: -webkit-box",
          "display: -moz-box",
          "display: -ms-flexbox",
          "display: -webkit-flex",
          "display: flex",
          "align-items: center",
          "justify-content: center",
          colors(theme)
        ].join("; ")
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

