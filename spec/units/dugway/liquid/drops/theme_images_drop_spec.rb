require 'spec_helper'

describe Dugway::Drops::ThemeImagesDrop do
  let(:customization) {
    {
      :logo => { :url => 'http://mysite.com/logo.png', :width => 100, :height => 50 },
      :background_image => { :url => 'http://mysite.com/bg.png', :width => 10, :height => 20 }
    }
  }

  let(:theme_images) {
    Dugway::Drops::ThemeImagesDrop.new(Dugway.theme.customization.update(customization.stringify_keys)).tap { |drop|
      drop.context = Liquid::Context.new({}, {}, { :settings => Dugway.theme.settings })
    }
  }

  describe "when an image for a given variable exists" do
    it "should return the liquified image" do
      logo = theme_images.logo
      logo.should_not be_nil
      logo.should be_an_instance_of(Dugway::Drops::ImageDrop)
    end
  end

  describe "when an image for a given variable does not exist" do
    it "should return nil" do
      theme_images.faker.should be_nil
    end
  end
end

