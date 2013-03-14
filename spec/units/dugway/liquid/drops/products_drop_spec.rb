require 'spec_helper'

describe Dugway::Drops::ProductsDrop do
  let(:order) { 'position' }
  let(:params) { {} }
  let(:registers) { { :params => params } }

  let(:products) {
    Dugway::Drops::ProductsDrop.new(Dugway.store.products.map { |p| Dugway::Drops::ProductDrop.new(p) }).tap { |drop|
      drop.context = Liquid::Context.new([{}, { 'internal' => { 'order' => order }}], {}, registers)
    }
  }

  describe "#all" do
    it "should return an array of all products" do
      all = products.all
      all.should be_an_instance_of(WillPaginate::Collection)
      all.size.should == 3

      product = all.first
      product.should be_an_instance_of(Dugway::Drops::ProductDrop)
      product.name.should == 'My Product'
    end
  end

  describe "#current" do
    it "should return an array of current products" do
      current = products.current
      current.should be_an_instance_of(WillPaginate::Collection)
      current.size.should == 3

      product = current.first
      product.should be_an_instance_of(Dugway::Drops::ProductDrop)
      product.name.should == 'My Product'
    end

    describe "when filtering by artist" do
      before(:each) do
        registers.merge!(:artist => { 'permalink' => 'artist-one' })
      end

      it "should return an array of the artist's products" do
        current = products.current
        current.should be_an_instance_of(WillPaginate::Collection)
        current.size.should == 1

        product = current.first
        product.should be_an_instance_of(Dugway::Drops::ProductDrop)
        product.name.should == 'My Product'
      end
    end

    describe "when filtering by category" do
      before(:each) do
        registers.merge!(:category => { 'permalink' => 'tees' })
      end

      it "should return an array of the category's products" do
        current = products.current
        current.should be_an_instance_of(WillPaginate::Collection)
        current.size.should == 2

        product = current.first
        product.should be_an_instance_of(Dugway::Drops::ProductDrop)
        product.name.should == 'My Product'
      end
    end

    describe "when searching" do
      before(:each) do
        registers[:params].merge!(:search => 'my product')
      end

      it "should return an array of the category's products" do
        current = products.current
        current.should be_an_instance_of(WillPaginate::Collection)
        current.size.should == 1

        product = current.first
        product.should be_an_instance_of(Dugway::Drops::ProductDrop)
        product.name.should == 'My Product'
      end
    end
  end

  describe "#on_sale" do
    it "should return an array of on sale products" do
      current = products.on_sale
      current.should be_an_instance_of(WillPaginate::Collection)
      current.size.should == 1

      product = current.first
      product.should be_an_instance_of(Dugway::Drops::ProductDrop)
      product.name.should == 'Print'
    end
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
    it "should return the product by permalink" do
      product = products.print
      product.should be_an_instance_of(Dugway::Drops::ProductDrop)
      product.name.should == 'Print'
    end

    it "should return the nil for an invalid permalink" do
      products.blah.should be_nil
    end
  end
end
