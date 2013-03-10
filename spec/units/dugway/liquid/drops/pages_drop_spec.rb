require 'spec_helper'

describe Dugway::Drops::PagesDrop do
  let(:pages) { Dugway::Drops::PagesDrop.new(Dugway.store.pages.map { |p| Dugway::Drops::PageDrop.new(p) }) }

  describe "#all" do
    it "should return an array of all pages" do
      all = pages.all
      all.should be_an_instance_of(Array)
      all.size.should == 1

      page = all.first
      page.should be_an_instance_of(Dugway::Drops::PageDrop)
      page.name.should == 'About Us'
    end
  end

  describe "#permalink" do
    it "should return the page by permalink" do
      page = pages.contact
      page.should be_an_instance_of(Dugway::Drops::PageDrop)
      page.name.should == 'Contact'
    end

    it "should return the nil for an invalid permalink" do
      pages.blah.should be_nil
    end
  end
end
