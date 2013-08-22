require 'spec_helper'

describe "For Loops" do
  let(:products) { Dugway.store.products }
  let(:products_drop) { Dugway::Drops::ProductsDrop.new(products) }

  it "should render each product name" do
    template = rendered_template("{% for product in products.all %} {{product.name}} {% endfor %}", 'products' => products_drop)
    products.each do |product|
      template.should =~ /#{Regexp.escape(product['name'])}/
    end
  end

  private

  def rendered_template(template, assigns={})
    Liquid::Template.parse(template).render(assigns, :registers => { :currency => Dugway.store.currency })
  end
end