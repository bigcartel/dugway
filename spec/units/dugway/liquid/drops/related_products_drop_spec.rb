require 'spec_helper'

describe Dugway::Drops::RelatedProductsDrop do
  let(:product) do
    {
      'id' => 1,
      'category_ids' => [1, 2],
      'name' => 'Sample Product'
    }
  end

  let(:related_product_1) do
    {
      'id' => 2,
      'category_ids' => [1],
      'name' => 'Related Product 1'
    }
  end

  let(:related_product_2) do
    {
      'id' => 3,
      'category_ids' => [2],
      'name' => 'Related Product 2'
    }
  end

  let(:unrelated_product) do
    {
      'id' => 4,
      'category_ids' => [3],
      'name' => 'Unrelated Product'
    }
  end

  let(:theme) { double('Dugway::Theme') }
  let(:theme_customization) do
    {
      'related_items' => 2,
      'related_products_order' => 'position'
    }
  end

  before do
    allow(Dugway.store).to receive(:products).and_return([
      product,
      related_product_1,
      related_product_2,
      unrelated_product
    ])
    allow(Dugway).to receive(:theme).and_return(theme)
    allow(theme).to receive(:customization).and_return(theme_customization)
  end

  let(:drop) { described_class.new(product) }

  describe "#products" do
    it "returns related products within the same categories" do
      products = drop.products
      expect(products.map { |p| p['id'] }).to match_array([2, 3])
    end

    it "limits the number of related products returned" do
      allow(theme).to receive(:customization).and_return({ 'related_items' => 1 })
      products = drop.products
      expect(products.size).to eq(1)
    end

    it "excludes the original product from the results" do
      products = drop.products
      expect(products.map { |p| p['id'] }).not_to include(product['id'])
    end

    it "falls back to other products if category matches are insufficient" do
      product['category_ids'] = [] # No categories
      products = drop.products
      expect(products.map { |p| p['id'] }).to match_array([2, 3])
    end
  end
end
