require 'spec_helper'

describe Dugway::Store do
  let(:store) { Dugway::Store.new('dugway') }

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
      store.theme_pages.size.should == 6
      store.theme_pages.first.should == { 'name' => 'Home', 'permalink' => 'home', 'url' => '/', 'category' => 'theme' }
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
      store.pages.size.should == 7
      store.pages.first.should == { 'name' => 'Home', 'permalink' => 'home', 'url' => '/', 'category' => 'theme' }
      store.pages.last.should == { 'category' => 'custom', 'content' => "<p>We're really cool!</p>", 'permalink' => 'about-us', 'name' => 'About Us', 'id' => 95821979, 'url' => '/about-us' }
    end
  end

  describe "#page" do
    it "should return a theme page by permalink" do
      store.page('home').should == { 'name' => 'Home', 'permalink' => 'home', 'url' => '/', 'category' => 'theme' }
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

  describe "#category_products" do
    it "should return an array of products for that category" do
      products = store.category_products('tees')
      products.size.should == 2
      products.first['name'].should == 'My Product'
    end

    it "should return an empty array with a bad permalink" do
      store.category_products('blah').should == []
    end
  end

  describe "#artists" do
    it "should return an array of the store's artists" do
      store.artists.should be_present
      store.artists.size.should == 3
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

  describe "#artist_products" do
    it "should return an array of products for that artist" do
      products = store.artist_products('artist-one')
      products.size.should == 1
      products.first['name'].should == 'My Product'
    end

    it "should return an empty array with a bad permalink" do
      store.artist_products('blah').should == []
    end
  end

  describe "#products" do
    it "should return an array of the store's products" do
      store.products.should be_present
      store.products.size.should == 3
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

  describe "#product_and_option" do
    it "should a product and option by option id" do
      product, option = store.product_and_option(29474321)
      product['name'].should == 'My Product'
      option['name'].should == 'Small'
    end

    it "should return nil with a bad option id" do
      store.product_and_option(12345).should be_nil
    end
  end

  describe "#previous_product" do
    it "should return the previous product when there is one" do
      store.previous_product('my-tee')['name'].should == 'My Product'
    end

    it "should return nil when there isn't one" do
      store.previous_product('my-product').should be_nil
    end
  end

  describe "#next_product" do
    it "should return the next product when there is one" do
      store.next_product('my-tee')['name'].should == 'Print'
    end

    it "should return nil when there isn't one" do
      store.next_product('my-print').should be_nil
    end
  end

  describe "#search_products" do
    it "should return an array of products for that search term" do
      products = store.search_products('product')
      products.size.should == 1
      products.first['name'].should == 'My Product'
    end

    it "should return an empty array with a bad permalink" do
      store.search_products('blah').should == []
    end
  end

  describe "#related_products" do
    it "returns an array of products with the same categories" do
      expect(store.related_products(store.products.first)).to eql([store.products[1]])
    end

    context "with a no products in the same category" do
      it "returns an empty array" do
        expect(store.related_products(store.products.last)).to eql([])
      end
    end
  end


  describe "#country" do
    it "returns the store's country" do
      store.country.should == { 'name' => 'United States', 'id' => 43, 'code' => 'US' }
    end
  end

  describe "#currency" do
    it "returns the store's currency" do
      store.currency.should == { 'sign' => '$', 'name' => 'U.S. Dollar', 'id' => 1, 'code' => 'USD', 'locale' => 'en-US' }
    end
  end

  describe "#locale" do
    it "returns the store's locale based on their currency" do
      store.locale.should == 'en-US'
    end
  end
end
