require 'spec_helper'

describe Dugway::Drops::CartItemDrop do
  let(:cart) { 
    Dugway::Drops::CartDrop.new(
      Dugway::Cart.new.tap { |cart|
        product_option = Dugway.store.products.first['options'].first
        cart.update(add: { id: product_option['id'], quantity: 2 })
      }
    )
  }

  let(:cart_item) { cart.items.first }

  describe "#id" do
    it "should return the id of the item" do
      cart_item.id.should == 1
    end
  end

  describe "#name" do
    it "should return the name of the item's product + option name" do
      cart_item.name.should == 'My Product - Small'
    end
  end

  describe "#price" do
    it "should return the price of the item times its quantity" do
      cart_item.price.should == 20.0
    end
  end

  describe "#unit_price" do
    it "should return the price of the item" do
      cart_item.unit_price.should == 10.0
    end
  end

  describe "#shipping" do
    it "should return 0.0 because it's disabled" do
      cart_item.shipping.should == 0.0
    end
  end

  describe "#total" do
    it "should return the total of the item times its quantity plus shipping" do
      cart_item.total.should == 20.0
    end
  end

  describe "#quantity" do
    it "should return the quantity of the item" do
      cart_item.quantity.should == 2
    end
  end

  describe "#product" do
    it "should return a ProductDrop of the item's product" do
      product = cart_item.product
      product.should be_an_instance_of(Dugway::Drops::ProductDrop)
      product.name.should == 'My Product'
    end
  end

  describe "#option" do
    it "should return a ProductOptionDrop of the item's option" do
      option = cart_item.option
      option.should be_an_instance_of(Dugway::Drops::ProductOptionDrop)
      option.name.should == 'Small'
    end
  end
end
