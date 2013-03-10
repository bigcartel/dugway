require 'spec_helper'

describe Dugway::Drops::PageDrop do
  let(:page) { 
    page = Dugway.store.page('about-us')
    page['full_url'] = 'http://test.bigcartel.com/about-us'
    page['full_path'] = '/about-us'
    Dugway::Drops::PageDrop.new(page)
  }

  describe "#id" do
    it "should return the page's id" do
      page.id.should == 95821979
    end
  end

  describe "#name" do
    it "should return the page's name" do
      page.name.should == 'About Us'
    end
  end

  describe "#content" do
    it "should return the page's content" do
      page.content.should == "<p>We're really cool!</p>"
    end
  end

  describe "#category" do
    it "should return the page's category" do
      page.category.should == 'custom'
    end
  end

  describe "#permalink" do
    it "should return the page's permalink" do
      page.permalink.should == 'about-us'
    end
  end

  describe "#url" do
    it "should return the page's url" do
      page.url.should == '/about-us'
    end
  end

  describe "#full_url" do
    it "should return the page's full_url" do
      page.full_url.should == 'http://test.bigcartel.com/about-us'
    end
  end

  describe "#full_path" do
    it "should return the page's full_path" do
      page.full_path.should == '/about-us'
    end
  end

  describe "#meta_description" do
    it "should return the page's meta_description" do
      page.meta_description.should == 'Example meta description'
    end
  end

  describe "#meta_keywords" do
    it "should return the page's meta_keywords" do
      page.meta_keywords.should == 'example, key, words'
    end
  end
end
