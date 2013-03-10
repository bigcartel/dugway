require 'spec_helper'

describe Dugway::Drops::ProductDrop do
  let(:product) { Dugway::Drops::ProductDrop.new(Dugway.store.products.first) }

  describe "#id" do
    it "should return the product's id" do
      product.id.should == 9422939
    end
  end

  describe "#name" do
    it "should return the product's name" do
      product.name.should == 'My Product'
    end
  end

  describe "#permalink" do
    it "should return the product's permalink" do
      product.permalink.should == 'my-product'
    end
  end

  describe "#url" do
    it "should return the product's url" do
      product.url.should == '/product/my-product'
    end
  end

  describe "#edit_url" do
    it "should return the product's edit url" do
      product.edit_url.should == "http://bigcartel.com"
    end
  end

  describe "#position" do
    it "should return the product's position" do
      product.position.should == 1
    end
  end

  describe "#description" do
    it "should return the product's description" do
      product.description.should == 'This is a description of my product.'
    end
  end

  describe "#status" do
    it "should return the product's status" do
      product.status.should == 'active'
    end
  end

  describe "#created_at" do
    it "should return the product's created_at date" do
      product.created_at.should == Time.parse('2013-02-10T19:28:11-07:00')
    end
  end

  describe "#categories" do
    it "should return the product's categories" do
      categories = product.categories
      categories.should be_an_instance_of(Array)
      categories.size.should == 1

      product = categories.first
      product.should be_an_instance_of(Dugway::Drops::CategoryDrop)
      product.name.should == 'Tees'
    end
  end

  describe "#artists" do
    it "should return the product's artists" do
      artists = product.artists
      artists.should be_an_instance_of(Array)
      artists.size.should == 1

      artist = artists.first
      artist.should be_an_instance_of(Dugway::Drops::ArtistDrop)
      artist.name.should == 'Artist One'
    end
  end

  describe "#css_class" do
    it "should return the right css_class when active" do
      product.css_class.should == 'product'
    end

    it "should return the right css_class when sold out" do
      product.stub(:status) { 'sold-out' }
      product.css_class.should == 'product sold'
    end

    it "should return the right css_class when coming soon" do
      product.stub(:status) { 'coming-soon' }
      product.css_class.should == 'product soon'
    end

    it "should return the right css_class when on sale" do
      product.stub(:on_sale) { true }
      product.css_class.should == 'product sale'
    end

    it "should return the right css_class when non-active and on sale" do
      product.stub(:status) { 'sold-out' }
      product.stub(:on_sale) { true }
      product.css_class.should == 'product sold sale'
    end
  end

  describe "#price" do
    it "should return nil, because price is deprecated" do
      product.price.should be_nil
    end
  end

  describe "#default_price" do
    it "should return the product's default_price" do
      product.default_price.should == 10.0
    end
  end

  describe "#variable_pricing" do
    it "should return true when options have a different price" do
      product.variable_pricing.should be(true)
    end

    it "should return false when options have same price" do
      Dugway::Drops::ProductOptionDrop.any_instance.stub(:price) { 10.0 }
      product.variable_pricing.should be(false)
    end
  end

  describe "#min_price" do
    it "should return the product's lowest price" do
      product.min_price.should == 10.0
    end
  end

  describe "#max_price" do
    it "should return the product's highest price" do
      product.max_price.should == 15.0
    end
  end

  describe "#on_sale" do
    it "should return if the product is on sale" do
      product.on_sale.should be(false)
    end
  end

  describe "#has_default_option" do
    it "should return false if the product has multiple options" do
      product.has_default_option.should be(false)
    end

    it "should return false if the product has one option not named 'Default'" do
      product.stub(:options) { [Dugway::Drops::ProductOptionDrop.new({ 'name' => 'Blah'})] }
      product.has_default_option.should be(false)
    end

    it "should return true if the product has one option named 'Default'" do
      product.stub(:options) { [Dugway::Drops::ProductOptionDrop.new({ 'name' => 'Default'})] }
      product.has_default_option.should be(true)
    end
  end

  describe "#option" do
    it "should return the product's first option" do
      option = product.option
      option.should be_an_instance_of(Dugway::Drops::ProductOptionDrop)
      option.name.should == 'Small'
    end
  end

  describe "#options" do
    it "should return the product's options" do
      options = product.options
      options.should be_an_instance_of(Array)
      options.size.should == 4

      option = options.first
      option.should be_an_instance_of(Dugway::Drops::ProductOptionDrop)
      option.name.should == 'Small'
    end
  end

  describe "#options_in_stock" do
    it "should return the product's options, since we're not tracking inventory" do
      options = product.options
      options.should be_an_instance_of(Array)
      options.size.should == 4

      option = options.first
      option.should be_an_instance_of(Dugway::Drops::ProductOptionDrop)
      option.name.should == 'Small'
    end
  end

  describe "#shipping" do
    it "should return the product's shipping" do
      shipping = product.shipping
      shipping.should be_an_instance_of(Array)
      shipping.size.should == 2

      option = shipping.first
      option.should be_an_instance_of(Dugway::Drops::ShippingOptionDrop)
      option.country.name.should == 'United States'
    end
  end

  describe "#image" do
    it "should return the product's first image" do
      image = product.image
      image.should be_an_instance_of(Dugway::Drops::ImageDrop)
      image.url.should == 'http://cache1.bigcartel.com/product_images/92599166/mens_tee_1.jpg'
    end
  end

  describe "#images" do
    it "should return the product's images" do
      images = product.images
      images.should be_an_instance_of(Array)
      images.size.should == 5

      image = images.first
      image.should be_an_instance_of(Dugway::Drops::ImageDrop)
      image.url.should == 'http://cache1.bigcartel.com/product_images/92599166/mens_tee_1.jpg'
    end
  end

  describe "#image_count" do
    it "should return the product's image_count" do
      product.image_count.should == 5
    end
  end

  describe "#previous_product" do
    it "should return nil when there isn't one" do
      product.previous_product.should be_nil
    end

    describe "when there is one" do
      let(:product) { Dugway::Drops::ProductDrop.new(Dugway.store.products.last) }

      it "should return the previous product" do
        previous_product = product.previous_product
        previous_product.should be_an_instance_of(Dugway::Drops::ProductDrop)
        previous_product.name.should == 'My Tee'
      end
    end
  end

  describe "#next_product" do
    it "should return the next product when there is one" do
      next_product = product.next_product
      next_product.should be_an_instance_of(Dugway::Drops::ProductDrop)
      next_product.name.should == 'My Tee'
    end

    describe "when there isn't one" do
      let(:product) { Dugway::Drops::ProductDrop.new(Dugway.store.products.last) }

      it "should return nil" do
        product.next_product.should be_nil
      end
    end
  end
end
