require 'spec_helper'

describe Dugway::Drops::CategoryDrop do
  let(:category) { Dugway::Drops::CategoryDrop.new(Dugway.store.categories.last) }

  describe "#id" do
    it "should return the category's id" do
      category.id.should == 4615193
    end
  end

  describe "#name" do
    it "should return the category's name" do
      category.name.should == 'Tees'
    end
  end

  describe "#permalink" do
    it "should return the category's permalink" do
      category.permalink.should == 'tees'
    end
  end

  describe "#url" do
    it "should return the category's url" do
      category.url.should == '/category/tees'
    end
  end

  describe "#products" do
    it "should return the category's products" do
      products = category.products
      products.should be_an_instance_of(Array)

      product = products.first
      product.should be_an_instance_of(Dugway::Drops::ProductDrop)
      product.name.should == 'My Product'
    end
  end
end
