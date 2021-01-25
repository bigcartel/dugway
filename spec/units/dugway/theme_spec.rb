require 'spec_helper'

describe Dugway::Theme do
  let(:theme) { Dugway.theme }

  describe "#layout" do
    it "should return the theme's layout" do
      theme.layout.should == read_file('layout.html')
    end
  end

  describe "#settings" do
    it "should return a hash of the theme's settings" do
      theme.settings.should == JSON.parse(read_file('settings.json'))
    end
  end

  describe "#fonts" do
    it "should return a hash of font settings values" do
      theme.fonts.should == {
        'font' => 'Georgia',
        'header_font' => 'Helvetica'
      }
    end
  end

  describe "#images" do
    it "should return a hash of the image settings" do
      theme.images.should == {
        'logo' => { :url => 'images/logo_bc.png', :width => 1, :height => 1 }
      }
    end
  end

  describe "#image_sets" do
    it "should return a hash of the image set settings" do
      theme.image_sets.should == {
        'slideshow_images' => [
          { :url => 'images/slideshow/1.gif', :width => 1, :height => 1 },
          { :url => 'images/slideshow/2.gif', :width => 1, :height => 1 },
          { :url => 'images/slideshow/3.gif', :width => 1, :height => 1 },
          { :url => 'images/slideshow/4.gif', :width => 1, :height => 1 },
          { :url => 'images/slideshow/5.gif', :width => 1, :height => 1 }
        ]
      }
    end
  end

  describe "#customization" do
    it "should return a hash of font, color, option, images and image sets settings values" do
      theme.customization.should == {
        'background_color' => '#222222',
        'fixed_sidebar' => true,
        'font' => 'Georgia',
        'header_font' => 'Helvetica',
        'link_color' => 'red',
        'show_search' => false,
        'logo' => { :url => 'images/logo_bc.png', :width => 1, :height => 1 },
        'slideshow_images' => [
          { :url => "images/slideshow/1.gif", :width => 1, :height => 1 },
          { :url => "images/slideshow/2.gif", :width => 1, :height => 1 },
          { :url => "images/slideshow/3.gif", :width => 1, :height => 1 },
          { :url => "images/slideshow/4.gif", :width => 1, :height => 1 },
          { :url => "images/slideshow/5.gif", :width => 1, :height => 1 }
        ]
      }
    end

    describe "when there are overridden customization" do
      before(:each) do
        Dugway.stub(:theme) {
          Dugway::Theme.new(:fixed_sidebar => false, :link_color => 'blue')
        }
      end

      it "should merge those values into the defaults" do
        theme.customization.should == {
          'background_color' => '#222222',
          'fixed_sidebar' => false,
          'font' => 'Georgia',
          'header_font' => 'Helvetica',
          'link_color' => 'blue',
          'show_search' => false,
          'logo' => { :url => 'images/logo_bc.png', :width => 1, :height => 1 },
          'slideshow_images' => [
            { :url => "images/slideshow/1.gif", :width => 1, :height => 1 },
            { :url => "images/slideshow/2.gif", :width => 1, :height => 1 },
            { :url => "images/slideshow/3.gif", :width => 1, :height => 1 },
            { :url => "images/slideshow/4.gif", :width => 1, :height => 1 },
            { :url => "images/slideshow/5.gif", :width => 1, :height => 1 }
          ]
        }
      end
    end
  end

  describe "#name" do
    it "should return the theme's name" do
      theme.name.should == 'Test Theme'
    end
  end

  describe "#version" do
    it "should return the theme's version" do
      theme.version.should == '1.2.3'
    end
  end

  describe "#file_content" do
    it "should return the file content for most files" do
      %w( home.html products.html screenshot.jpg ).each { |file_name|
        theme.file_content(file_name).should == read_file(file_name)
      }
    end

    it "should sprocketize theme.js" do
      theme.file_content('theme.js').gsub(/\s+/, '').should == %{console.log('One');(function(){console.log('Two');}).call(this);}
    end

    it "should sprocketize and liquify theme.css" do
      theme.file_content('theme.css').gsub(/\s+/, '').should == %{html,body{height:100%;}a{background:#0f0;color:red;}footercitea{background:url(/images/bc_badge.png)no-repeat;}/**/}
    end
  end

  describe "#build_file" do
    it "should return the file content for most files" do
      %w( home.html products.html screenshot.jpg ).each { |file_name|
        theme.build_file(file_name).should == read_file(file_name)
      }
    end

    it "should sprocketize and compress theme.js" do
      theme.build_file('theme.js').should == %{console.log(\"One\"),function(){console.log(\"Two\")}.call(this);}
    end

    it "should sprocketize and not liquify theme.css" do
      theme.build_file('theme.css').gsub(/\s+/, '').should == %{html,body{height:100%;}a{background:#0f0;color:{{theme.link_color}};}footercitea{background:url({{'bc_badge.png'|theme_image_url}})no-repeat;}/**/}
    end
  end

  describe "#files" do
    it "should return an array of all files" do
      theme.files.should =~ ["cart.html", "contact.html", "home.html", "layout.html", "maintenance.html", "product.html", "products.html", "screenshot.jpg", "settings.json", "theme.css", "theme.js", "images/bc_badge.png", "images/logo_bc.png", "images/slideshow/1.gif", "images/slideshow/2.gif", "images/slideshow/3.gif", "images/slideshow/4.gif", "images/slideshow/5.gif", "images/small.svg", "fonts/icons.ttf", "fonts/icons.woff"]
    end
  end

  describe "#image_files" do
    it "should return an array of all image files" do
      theme.image_files.should =~ ["images/bc_badge.png", "images/logo_bc.png", "images/slideshow/1.gif", "images/slideshow/2.gif", "images/slideshow/3.gif", "images/slideshow/4.gif", "images/slideshow/5.gif", "images/small.svg"]
    end
  end

  describe "#font_files" do
    it "shoud return an array of all font files" do
      theme.font_files.should include("fonts/icons.ttf", "fonts/icons.woff")
    end
  end

  describe "#valid?" do
    it "should return true when a theme has everything it needs" do
      theme.valid?.should be(true)
      theme.errors.should be_empty
    end

    describe "when missing a required file" do
      before(:each) do
        theme.stub(:read_source_file).with('cart.html') { theme.unstub!(:read_source_file); nil }
      end

      it "should not be valid" do
        theme.valid?.should be(false)
        theme.errors.size.should == 1
        theme.errors.first.should == 'Missing source/cart.html'
      end
    end

    describe "when missing a name" do
      before(:each) do
        theme.stub(:name) { nil }
      end

      it "should not be valid" do
        theme.valid?.should be(false)
        theme.errors.size.should == 1
        theme.errors.first.should == 'Missing theme name in source/settings.json'
      end
    end

    describe "when missing a version" do
      before(:each) do
        theme.stub(:version) { nil }
      end

      it "should not be valid" do
        theme.valid?.should be(false)
        theme.errors.size.should == 1
        theme.errors.first.should == 'Invalid theme version in source/settings.json (ex: 1.0.3)'
      end
    end

    describe "when having an invalid version" do
      before(:each) do
        theme.stub(:version) { '1.3' }
      end

      it "should not be valid" do
        theme.valid?.should be(false)
        theme.errors.size.should == 1
        theme.errors.first.should == 'Invalid theme version in source/settings.json (ex: 1.0.3)'
      end
    end

    describe "when missing at least one image" do
      before(:each) do
        theme.stub(:image_files) { [] }
      end

      it "should not be valid" do
        theme.valid?.should be(false)
        theme.errors.size.should == 1
        theme.errors.first.should == 'Missing images in source/images'
      end
    end

    describe "when there are several errors" do
      before(:each) do
        theme.stub(:name) { nil }
        theme.stub(:version) { nil }
        theme.stub(:image_files) { [] }
      end

      it "should return all of them" do
        theme.valid?.should be(false)
        theme.errors.size.should == 3
      end
    end
  end

  def read_file(file_name)
    File.read(File.join(Dugway.source_dir, file_name))
  end
end

