require 'spec_helper'

describe Dugway::Drops::CountryDrop do
  let(:country) { Dugway::Drops::CountryDrop.new(Dugway.store.country) }

  describe "#name" do
    it "should return the country's name" do
      country.name.should == 'United States'
    end
  end

  describe "#code" do
    it "should return the country's code" do
      country.code.should == 'US'
    end
  end
end
