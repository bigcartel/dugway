require 'spec_helper'

describe Dugway::Drops::ImageDrop do
  let(:image) { Dugway::Drops::ImageDrop.new(Dugway.store.products.first['images'].first) }

  describe "#url" do
    it "should return the image's url" do
      image.url.should == 'http://cache1.bigcartel.com/product_images/92599166/mens_tee_1.jpg'
    end
  end

  describe "#width" do
    it "should return the image's width" do
      image.width.should == 475
    end
  end

  describe "#height" do
    it "should return the image's height" do
      image.height.should == 500
    end
  end
end
