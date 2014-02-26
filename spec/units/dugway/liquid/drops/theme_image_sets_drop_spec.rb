require 'spec_helper'

describe Dugway::Drops::ThemeImageSetsDrop do
  let(:customization) {
    {
      :slideshow_images => [
        { :url => 'http://mysite.com/slideshow_one.png', :width => 450, :height => 175 },
        { :url => 'http://mysite.com/slideshow_two.png', :width => 450, :height => 175 },
        { :url => 'http://mysite.com/slideshow_three.png', :width => 450, :height => 175 }
      ]
    }
  }

  let(:theme_image_sets) {
    Dugway::Drops::ThemeImageSetsDrop.new(Dugway.theme.customization.update(customization.stringify_keys)).tap { |drop|
      drop.context = Liquid::Context.new({}, {}, { :settings => Dugway.theme.settings })
    }
  }

  describe "when images for a given variable exists" do
    it "should return all images in an array" do
      images = theme_image_sets.slideshow_images
      images.should_not be_empty
      images.size.should == 3
    end
  end

  describe "when images for a given variable do not exist" do
    it "should return an empty array" do
      theme_image_sets.faker.should == []
    end
  end
end

