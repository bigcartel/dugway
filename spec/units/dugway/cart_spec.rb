require 'spec_helper'

describe Dugway::Cart do
  let(:cart) { Dugway::Cart.new }
  let(:store) { Dugway::Store.new('dugway') }
  
  let(:product) { store.products.first }
  let(:product_option) { product['options'].first }

  let(:product_2) { store.products.last }
  let(:product_option_2) { product_2['options'].first }

  describe "#new" do
    it "should have a blank items array" do
      cart.items.should be_an_instance_of(Array)
      cart.items.should be_empty
    end
  end

  describe "#reset" do
    before(:each) do
      cart.update(add: { id: product_option['id'] })
    end

    it "should empty the items array" do
      expect { cart.reset }.to change { cart.items.size }.from(1).to(0)
    end
  end

  describe "#item_count" do
    it "should return the number of items in the cart times their quantity" do
      cart.item_count.should == 0
      cart.update(add: { id: product_option['id'] })
      cart.item_count.should == 1
      cart.update(add: { id: product_option_2['id'], quantity: 2 })
      cart.item_count.should == 3
    end
  end

  describe "#empty?" do
    it "should return true or false if there are items in the cart" do
      cart.should be_empty
      cart.update(add: { id: product_option['id'] })
      cart.should_not be_empty
    end
  end

  describe "#subtotal" do
    it "should return the total of all item prices times their quantity" do
      cart.subtotal.should == 0.0
      
      cart.update(add: { id: product_option['id'], quantity: 1 })
      cart.subtotal.should == product_option['price']

      cart.update(add: { id: product_option_2['id'], quantity: 2 })
      cart.subtotal.should == product_option['price'] + (product_option_2['price'] * 2)
    end
  end

  describe "#total" do
    it "should return the total of all item prices times their quantity" do
      cart.total.should == 0.0
      
      cart.update(add: { id: product_option['id'], quantity: 1 })
      cart.total.should == product_option['price']

      cart.update(add: { id: product_option_2['id'], quantity: 2 })
      cart.total.should == product_option['price'] + (product_option_2['price'] * 2)
    end
  end

  describe "#country" do
    it "should return nil to disable it" do
      cart.country.should be_nil
    end
  end

  describe "#shipping" do
    it "should return a hash that disables it" do
      cart.shipping.should == { 
        'enabled' => false,
        'amount' => 0.0,
        'strict' => false,
        'pending' => false
      }
    end
  end

  describe "#tax" do
    it "should return a hash that disables it" do
      cart.tax.should == { 
        'enabled' => false,
        'amount' => 0.0
      }
    end
  end

  describe "#discount" do
    it "should return a hash that disables it" do
      cart.discount.should == { 
        'enabled' => false,
        'pending' => false,
        'amount' => 0.0
      }
    end
  end

  describe "#update" do
    describe "when adding individual items" do
      it "should add an item" do
        cart.items.should be_empty
        cart.update(add: { id: product_option['id'], quantity: 2 })
        cart.items.should_not be_empty

        item = cart.items.first
        item.product.should == product
        item.option.should == product_option
        item.quantity.should == 2
      end

      it "should default to quantity 1" do
        cart.items.should be_empty
        cart.update(add: { id: product_option['id'] })
        cart.items.should_not be_empty

        item = cart.items.first
        item.product.should == product
        item.option.should == product_option
        item.quantity.should == 1
      end

      it "should update the existing item when re-adding the same thing" do
        cart.items.should be_empty
        cart.update(add: { id: product_option['id'] })
        cart.items.should_not be_empty

        item = cart.items.first
        item.product.should == product
        item.option.should == product_option
        item.quantity.should == 1

        cart.update(add: { id: product_option['id'], quantity: 2 })

        item = cart.items.first
        item.product.should == product
        item.option.should == product_option
        item.quantity.should == 3
      end
    end

    describe "when adding multiple items at once" do
      it "should add multiple items" do
        cart.items.should be_empty
        cart.update(adds: [{ id: product_option['id'] }, { id: product_option_2['id'], quantity: 2 }])
        cart.item_count.should == 3

        item = cart.items.first
        item.product.should == product
        item.option.should == product_option
        item.quantity.should == 1

        item = cart.items.last
        item.product.should == product_2
        item.option.should == product_option_2
        item.quantity.should == 2
      end
    end

    describe "when updating items already in the cart" do
      before(:each) do
        cart.update(adds: [{ id: product_option['id'] }, { id: product_option_2['id'], quantity: 2 }])
      end

      it "should update the quanitities" do
        cart.item_count.should == 3
        
        item_1 = cart.items.first
        item_2 = cart.items.last

        cart.update(:update => { item_1.id => 3, item_2.id => 1 })
        cart.item_count.should == 4
      end
    end
  end

  describe "#as_json" do
    before(:each) do
      cart.update(adds: [{ id: product_option['id'] }, { id: product_option_2['id'], quantity: 2 }])
    end

    it "should output the cart as JSON" do
      cart.as_json.should match_json_expression({
        :item_count => cart.item_count,
        :subtotal => cart.subtotal,
        :price => cart.subtotal,
        :total => cart.total,
        :items => cart.items,
        :country => cart.country,
        :shipping => cart.shipping,
        :discount => cart.discount
      })
    end
  end
end
