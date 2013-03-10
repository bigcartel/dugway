require 'spec_helper'

describe Dugway::Drops::ProductsDrop do
  let(:order) { 'position' }

  let(:products) { 
    Dugway::Drops::ProductsDrop.new(Dugway.store.products.map { |p| Dugway::Drops::ProductDrop.new(p) }).tap { |drop|
      drop.context = Liquid::Context.new([{}, { 'internal' => { 'order' => order }}], {}, {})
    }
  }

  describe "#all" do
    it "should return an array of all products"
  end

  describe "#current" do
    it "should return an array of all current products"
  end

  describe "#on_sale" do
    it "should return an array of all on sale products"
  end

  describe "#top_selling" do
    it "should return nil, since it's deprecated" do
      products.top_selling.should be_nil
    end
  end

  describe "#newest" do
    it "should return nil, since it's deprecated" do
      products.newest.should be_nil
    end
  end

  describe "#featured" do
    it "should return nil, since it's deprecated" do
      products.featured.should be_nil
    end
  end

  describe "#permalink" do
    it "should return the product by permalink"

    it "should return the nil for an invalid permalink" do
      products.blah.should be_nil
    end
  end
end
