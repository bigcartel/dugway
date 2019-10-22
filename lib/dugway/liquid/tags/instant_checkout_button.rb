module Dugway
  module Tags
    class InstantCheckoutButton < Liquid::Tag
      def initialize(*args)
        super
        options = args[1].strip.downcase

        if options =~ /^(dark|light)/
          @theme, @height = *options.split(":")
        else
          @theme = @height = nil
        end
      end

    #  def initialize(theme=nil, height=nil)
    #    @theme,@height = theme,height
    #  end
      def render(context)
        account = context.registers[:account]

        return nil unless account.using_stripe?

        div_styles = generate_div_styles
        anchor_styles = generate_anchor_styles

        %(<div id="instant-checkout-button" style="#{ div_styles }"><a href="https://help.bigcartel.com/instant-checkout" target="_new" style="#{ anchor_styles }">Instant Checkout</a></div>)
      end

      private

      def generate_div_styles
        styles = [
          "border-radius: 3px",
          "padding: 10px",
          "font-size: 20px",
          "font-weight: bold",
          colors
        ]

        styles << "border: 1px solid black" if @theme == "light-outline"
        styles << "height: #{ @height }" if @height

        styles.join("; ")
      end

      def generate_anchor_styles
        [
          "height: 100%",
          "display: -webkit-box",
          "display: -moz-box",
          "display: -ms-flexbox",
          "display: -webkit-flex",
          "display: flex",
          "align-items: center",
          "justify-content: center",
          colors
        ].join("; ")
      end

      def colors
        if @theme =~ /\Alight/
          "background-color: white; color: black"
        else
          "background-color: black; color: white"
        end
      end
    end
  end
end
