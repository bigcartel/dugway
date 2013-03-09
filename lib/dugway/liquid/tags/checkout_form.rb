module Dugway
  module Tags
    class CheckoutForm < ::Liquid::Block
      def render(context)
        %{<form id="checkout_form" name="checkout_form" method="post" action="/success">#{ render_all(@nodelist, context) }</form>}
      end
    end
  end
end
