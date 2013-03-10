require 'spec_helper'

describe Dugway::Drops::CartDrop do
  let(:cart) { 
    Dugway::Drops::CartDrop.new(
      Dugway::Cart.new.tap { |cart|
        product_option = Dugway.store.products.first['options'].first
        product_option_2 = Dugway.store.products.last['options'].first
        cart.update(adds: [{ id: product_option['id'] }, { id: product_option_2['id'], quantity: 2 }])
      }
    )
  }

  describe "#item_count" do
    it "should return the number of items times quantity" do
      cart.item_count.should == 3
    end
  end

  describe "#price" do
    it "should return nil, since it's deprecated" do
      cart.price.should be_nil
    end
  end

  describe "#subtotal" do
    it "should the cart's subtotal" do
      cart.subtotal.should == 50.0
    end
  end

  describe "#total" do
    it "should the cart's total" do
      cart.total.should == 50.0
    end
  end

  describe "#items" do
    it "should return an array of the items" do
      items = cart.items
      items.should be_an_instance_of(Array)
      items.size.should == 2

      item = items.first
      item.should be_an_instance_of(Dugway::Drops::CartItemDrop)
      item.name.should == 'My Product - Small'
    end
  end

  describe "#country" do
    it "should return nil, since it's disabled" do
      cart.country.should be_nil
    end
  end

  describe "#shipping" do
    it "should return a hash of values" do
      shipping = cart.shipping
      shipping['enabled'].should be(false)
      shipping['strict'].should be(false)
      shipping['pending'].should be(false)
      shipping['amount'].should == 0.0
    end
  end

  describe "#discount" do
    it "should return a hash of values" do
      discount = cart.discount
      discount['enabled'].should be(false)
      discount['pending'].should be(false)
      discount['name'].should be(nil)
      discount['amount'].should == 0.0
      discount['code'].should be(nil)
      discount['type'].should be(nil)
      discount['percent_discount'].should be(nil)
      discount['flat_rate_discount'].should be(nil)
      discount['free_shipping'].should be(nil)
      discount['percent'].should be(nil)
    end
  end
end
