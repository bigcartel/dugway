require 'spec_helper'

describe Dugway::Drops::AccountDrop do
  let(:account) { Dugway::Drops::AccountDrop.new(Dugway.store.account) }

  describe "#name" do
    it "should return the store's name" do
      account.name.should == 'Dugway'
    end
  end

  describe "#description" do
    it "should return the store's description" do
      account.description.should == 'A really cool store.'
    end
  end

  describe "#url" do
    it "should return the store's url" do
      account.url.should == 'http://dugway.bigcartel.com'
    end
  end

  describe "#website" do
    it "should return the store's website" do
      account.website.should == 'https://github.com/bigcartel/dugway'
    end
  end

  describe "#currency" do
    it "should return the store's currency" do
      currency = account.currency
      currency.should be_an_instance_of(Dugway::Drops::CurrencyDrop)
      currency.name.should == 'U.S. Dollar'
      currency.code.should == 'USD'
      currency.sign.should == '$'
    end
  end

  describe "#country" do
    it "should return the store's country" do
      country = account.country
      country.should be_an_instance_of(Dugway::Drops::CountryDrop)
      country.name.should == 'United States'
      country.code.should == 'US'
    end
  end

  describe "#logged_in" do
    it "should return false" do
      account.logged_in.should be(false)
    end
  end
end
