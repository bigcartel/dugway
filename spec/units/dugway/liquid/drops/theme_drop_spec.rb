require 'spec_helper'

describe Dugway::Drops::ThemeDrop do
  let(:customization) {{
    :logo => { :url => 'http://mysite.com/logo.png', :width => 100, :height => 50 },
    :background_image => { :url => 'http://mysite.com/bg.png', :width => 10, :height => 20 }
  }}

  let(:theme) { Dugway::Drops::ThemeDrop.new(Dugway.theme.customization.update(customization.stringify_keys)).tap { |drop|
    drop.context = Liquid::Context.new({}, {}, { :settings => Dugway.theme.settings })
  }}

  describe "#logo" do
    it "should return the theme's logo" do
      logo = theme.logo
      logo.should be_an_instance_of(Dugway::Drops::ImageDrop)
      logo.url.should == 'http://mysite.com/logo.png'
      logo.width.should == 100
      logo.height.should == 50
    end
  end

  describe "#background_image" do
    it "should return the theme's background_image" do
      background_image = theme.background_image
      background_image.should be_an_instance_of(Dugway::Drops::ImageDrop)
      background_image.url.should == 'http://mysite.com/bg.png'
      background_image.width.should == 10
      background_image.height.should == 20
    end
  end

  describe "#header_font" do
    it "should return the theme's header_font" do
      theme.header_font.should == 'Helvetica'
    end
  end

  describe "#font" do
    it "should return the theme's font" do
      theme.font.should == 'Georgia'
    end
  end

  describe "#background_color" do
    it "should return the theme's background_color" do
      theme.background_color.should == '#222222'
    end
  end

  describe "#link_color" do
    it "should return the theme's link_color" do
      theme.link_color.should == 'red'
    end
  end

  describe "#show_search" do
    it "should return the theme's show_search" do
      theme.show_search.should be(false)
    end
  end

  describe "#fixed_sidebar" do
    it "should return the theme's fixed_sidebar" do
      theme.fixed_sidebar.should be(true)
    end
  end
end
