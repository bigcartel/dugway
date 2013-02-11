class CheckoutForm < ::Liquid::Block
  def render(context)
    %{<form id="checkout_form" name="checkout_form" method="post" action="/checkout"></form>}
  end
end
