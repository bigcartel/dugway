require 'spec_helper'

describe Dugway::Drops::ProductOptionDrop do
  let(:product) { Dugway::Drops::ProductDrop.new(Dugway.store.products.first) }
  let(:option) { product.option }

  describe "#id" do
    it "should return the option's id" do
      option.id.should == 29474321
    end
  end

  describe "#name" do
    it "should return the option's name" do
      option.name.should == 'Small'
    end
  end

  describe "#price" do
    it "should return the option's price" do
      option.price.should == 10.0
    end
  end

  describe "#has_custom_price" do
    it "should return false when it has the same price" do
      option.has_custom_price.should be(false)
    end

    it "should return true when it has a different price" do
      option.stub(:price) { 25.0 }
      option.has_custom_price.should be(true)
    end
  end

  describe "#position" do
    it "should return the option's position" do
      option.position.should == 1
    end
  end

  describe "#sold" do
    it "should return a random number" do
      option.sold.should be >= 0
    end
  end

  describe "#sold_out" do
    it "should return whether the option's sold_out" do
      option.sold_out.should be(false)
    end
  end

  describe "#quantity" do
    it "should return a positivie random number if not sold_out" do
      option.quantity.should be >= 0
    end

    it "should return 0 when it is sold_out" do
      option.stub(:sold_out) { true }
      option.quantity.should be(0)
    end
  end

  describe "#inventory" do
    it "should return the option's calculated inventory" do
      option.stub(:quantity) { 25 }
      option.stub(:sold) { 75 }
      option.inventory.should be(25)
    end
  end

  describe "#default" do
    it "should true if it's the default option" do
      option.default.should be(true)
    end

    describe "when it's not the default option" do
      let(:option) { product.options.last }

      it "should return false" do
        option.default.should be(false)
      end
    end
  end
end
