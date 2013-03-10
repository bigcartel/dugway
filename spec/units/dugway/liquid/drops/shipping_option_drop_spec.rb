require 'spec_helper'

describe Dugway::Drops::ShippingOptionDrop do
  let(:product) { Dugway::Drops::ProductDrop.new(Dugway.store.products.first) }
  let(:shipping) { product.shipping.first }

  describe "#amount_alone" do
    it "should return the shipping's amount_alone" do
      shipping.amount_alone.should == 10.0
    end
  end

  describe "#amount_with_others" do
    it "should return the shipping's amount_with_others" do
      shipping.amount_with_others.should == 5.0
    end
  end

  describe "#country" do
    it "should return the shipping's country" do
      country = shipping.country
      country.should be_an_instance_of(Dugway::Drops::CountryDrop)
      country.name.should == 'United States'
    end
  end
end
