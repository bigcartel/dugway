require 'spec_helper'

describe Dugway::Store do
  let(:store) { Dugway::Store.new('dugway') }
  
  before(:each) do
    stub_request(:get, /.*api\.bigcartel\.com.*/).to_return(lambda { |request|
      { :body => File.new(File.join(RSpec.configuration.fixture_path, 'store', request.uri.path.split('/', 3).last)), :status => 200, :headers => {} }
    })
  end
  
  describe "#account" do
    it "should return account params" do
      store.account.should be_present
      store.account['name'].should == 'Dugway'
      store.account['url'].should == 'http://dugway.bigcartel.com'
    end
  end
  
  describe "#theme_pages" do
    it "should return an array of the default theme pages" do
      store.theme_pages.should be_present
      store.theme_pages.size.should == 8
      store.theme_pages.first.should == { 'name' => 'Home', 'permalink' => 'home', 'url' => '/' }
    end
  end
  
  describe "#custom_pages" do
    it "should return an array of the store's custom pages" do
      store.custom_pages.should be_present
      store.custom_pages.size.should == 1
      store.custom_pages.first.should == { 'category' => 'custom', 'content' => "<p>We're really cool!</p>", 'permalink' => 'about-us', 'name' => 'About Us', 'id' => 95821979, 'url' => '/about-us' }
    end
  end
  
  describe "#pages" do
    it "should return an array of the combined theme and custom pages" do
      store.pages.should be_present
      store.pages.size.should == 9
      store.pages.first.should == { 'name' => 'Home', 'permalink' => 'home', 'url' => '/' }
      store.pages.last.should == { 'category' => 'custom', 'content' => "<p>We're really cool!</p>", 'permalink' => 'about-us', 'name' => 'About Us', 'id' => 95821979, 'url' => '/about-us' }
    end
  end
  
  describe "#page" do
    it "should return a theme page by permalink" do
      store.page('home').should == { 'name' => 'Home', 'permalink' => 'home', 'url' => '/' }
    end
    
    it "should return a custom page by permalink" do
      store.page('about-us').should == { 'category' => 'custom', 'content' => "<p>We're really cool!</p>", 'permalink' => 'about-us', 'name' => 'About Us', 'id' => 95821979, 'url' => '/about-us' }
    end
    
    it "should return nil with a bad permalink" do
      store.page('blah').should be_nil
    end
  end
  
  describe "#categories" do
    it "should return an array of the store's categories" do
      store.categories.should be_present
      store.categories.size.should == 4
      store.categories.first.should == { 'permalink' => 'cds', 'name' => 'CDs', 'id' => 4615184, 'url' => '/category/cds' }
    end
  end
  
  describe "#category" do
    it "should return a category by permalink" do
      store.category('cds').should == { 'permalink' => 'cds', 'name' => 'CDs', 'id' => 4615184, 'url' => '/category/cds' }
    end
    
    it "should return nil with a bad permalink" do
      store.category('blah').should be_nil
    end
  end
  
  describe "#artists" do
    it "should return an array of the store's artists" do
      store.artists.should be_present
      store.artists.size.should == 2
      store.artists.first.should == { 'permalink' => 'artist-one', 'name' => 'Artist One', 'id' => 176141, 'url' => '/artist/artist-one' }
    end
  end
  
  describe "#artist" do
    it "should return an artist by permalink" do
      store.artist('artist-one').should == { 'permalink' => 'artist-one', 'name' => 'Artist One', 'id' => 176141, 'url' => '/artist/artist-one' }
    end
    
    it "should return nil with a bad permalink" do
      store.artist('blah').should be_nil
    end
  end
  
  describe "#products" do
    it "should return an array of the store's products" do
      store.products.should be_present
      store.products.size.should == 1
      store.products.first['name'].should == 'My Product'
    end
  end
  
  describe "#product" do
    it "should return a product by permalink" do
      store.product('my-product')['name'].should == 'My Product'
    end
    
    it "should return nil with a bad permalink" do
      store.product('blah').should be_nil
    end
  end
  
  describe "#currency" do
    it "returns the store's currency" do
      store.currency.should == { 'sign' => '$', 'name' => 'U.S. Dollar', 'id' => 1, 'code' => 'USD' }
    end
  end
  
  describe "#country" do
    it "returns the store's country" do
      store.country.should == { 'name' => 'United States', 'id' => 43, 'code' => 'US' }
    end
  end
end
