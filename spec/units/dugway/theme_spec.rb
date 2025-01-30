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
        'text_font' => 'Georgia',
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
        'background_color' => 'white',
        'fixed_sidebar' => true,
        'text_font' => 'Georgia',
        'header_font' => 'Helvetica',
        'primary_text_color' => 'black',
        'link_text_color' => 'red',
        'link_hover_color' => 'black',
        'button_background_color' => 'black',
        'button_text_color' => 'white',
        'button_hover_background_color' => 'red',
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
          Dugway::Theme.new(:fixed_sidebar => false, :link_text_color => 'blue')
        }
      end

      it "should merge those values into the defaults" do
        theme.customization.should == {
          'background_color' => 'white',
          'fixed_sidebar' => false,
          'text_font' => 'Georgia',
          'header_font' => 'Helvetica',
          'primary_text_color' => 'black',
          'link_text_color' => 'blue',
          'link_hover_color' => 'black',
          'button_background_color' => 'black',
          'button_text_color' => 'white',
          'button_hover_background_color' => 'red',
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
      theme.file_content('theme.css').gsub(/\s+/, '').should == %{html,body{height:100%;}a{background:#0f0;color:red;}/**/}
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
      theme.build_file('theme.css').gsub(/\s+/, '').should == %{html,body{height:100%;}a{background:#0f0;color:{{theme.link_text_color}};}/**/}
    end
  end

  describe "#files" do
    it "should return an array of all files" do
      theme.files.should =~ ["cart.html", "contact.html", "home.html", "layout.html", "maintenance.html", "product.html", "products.html", "screenshot.jpg", "settings.json", "theme.css", "theme.js", "images/logo_bc.png", "images/slideshow/1.gif", "images/slideshow/2.gif", "images/slideshow/3.gif", "images/slideshow/4.gif", "images/slideshow/5.gif", "images/small.svg", "fonts/icons.ttf", "fonts/icons.woff"]
    end
  end

  describe "#image_files" do
    it "should return an array of all image files" do
      theme.image_files.should =~ ["images/logo_bc.png", "images/slideshow/1.gif", "images/slideshow/2.gif", "images/slideshow/3.gif", "images/slideshow/4.gif", "images/slideshow/5.gif", "images/small.svg"]
    end
  end

  describe "#font_files" do
    it "should return an array of all font files" do
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
        theme.stub(:read_source_file).with('cart.html') { theme.unstub(:read_source_file); nil }
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

    describe "when there are several errors" do
      before(:each) do
        theme.stub(:name) { nil }
        theme.stub(:version) { nil }
      end

      it "should return all of them" do
        theme.valid?.should be(false)
        theme.errors.size.should == 2
      end
    end

    describe "when preset styles are invalid" do
      let(:valid_settings) do
        {
          'fonts' => [{'variable' => 'font'}],
          'colors' => [
            {'variable' => 'background_color'},
            {'variable' => 'primary_text_color'},
            {'variable' => 'link_text_color'},
            {'variable' => 'link_hover_color'},
            {'variable' => 'button_background_color'},
            {'variable' => 'button_text_color'},
            {'variable' => 'button_hover_background_color'}
          ],
          'preset_styles' => {
            'preview' => {
              'title_font' => 'font',
              'body_font' => 'font',
              'text_color' => '#000000',
              'background_color' => '#FFFFFF'
            },
            'presets' => [{
              'group_name' => 'Classic',
              'styles' => [{
                'style_name' => 'Style 1',
                'fonts' => {'font' => 'Arial'},
                'colors' => {
                  'background_color' => '#FFFFFF',
                  'primary_text_color' => '#000000',
                  'link_text_color' => '#000000',
                  'link_hover_color' => '#000000',
                  'button_background_color' => '#000000',
                  'button_text_color' => '#FFFFFF',
                  'button_hover_background_color' => '#000000'
                }
              }]
            }]
          }
        }
      end

      before(:each) do
        allow(theme).to receive(:name) { "Test Theme" }
        allow(theme).to receive(:version) { "1.2.3" }
      end

      it "requires non-empty group_name" do
        settings = valid_settings
        settings['preset_styles']['presets'].first['group_name'] = ' '
        theme.stub(:settings) { settings }
        theme.valid?.should be(false)
        theme.errors.should include('Preset is missing group_name')
      end

      it "requires non-empty style_name" do
        settings = valid_settings
        settings['preset_styles']['presets'].first['styles'].first['style_name'] = '  '
        theme.stub(:settings) { settings }
        theme.valid?.should be(false)
        theme.errors.should include('Style in group \'Classic\' - Missing style_name')
      end
    end

    describe "when missing option descriptions" do
      before(:each) do
        theme.stub(:settings) { {
          'name' => 'Test Theme',
          'version' => '1.2.3',
          'options' => [{ 'variable' => 'show_search', 'label' => 'Show search' }]
        } }
      end

      it "should not be valid" do
        theme.valid?.should be(false)
        theme.errors.size.should == 1
        theme.errors.first.should == 'Missing descriptions for options: show_search'
      end

      it "should be valid when skipping options validation" do
        theme.valid?(validate_options: false).should be(true)
      end
    end

    describe "when validating option requirements" do
      before(:each) do
        # Ensure basic theme validation passes
        allow(theme).to receive(:name) { "Test Theme" }
        allow(theme).to receive(:version) { "1.2.3" }
      end

      def setup_theme_with_options(options)
        allow(theme).to receive(:settings) { {
          'name' => 'Test Theme',
          'version' => '1.2.3',
          'options' => options
        } }
      end

      it "allows options with no requires" do
        setup_theme_with_options([
          {
            'variable' => 'show_search',
            'label' => 'Show search',
            'description' => 'Show search in header'
          }
        ])

        theme.valid?.should be(true)
        theme.errors.should be_empty
      end

      it "allows options that only require inventory" do
        setup_theme_with_options([
          {
            'variable' => 'show_inventory',
            'label' => 'Show inventory',
            'description' => 'Shows inventory count',
            'requires' => 'inventory'
          }
        ])

        theme.valid?.should be(true)
        theme.errors.should be_empty
      end

      it "allows options with valid setting dependencies" do
        setup_theme_with_options([
          {
            'variable' => 'show_search',
            'label' => 'Show search',
            'description' => 'Show search in header'
          },
          {
            'variable' => 'search_placeholder',
            'label' => 'Search placeholder',
            'description' => 'Placeholder text for search',
            'requires' => ['show_search eq true']
          }
        ])

        theme.valid?.should be(true)
        theme.errors.should be_empty
      end

      it "catches invalid setting references" do
        setup_theme_with_options([
          {
            'variable' => 'search_placeholder',
            'label' => 'Search placeholder',
            'description' => 'Placeholder text for search',
            'requires' => ['nonexistent_setting eq true']
          }
        ])

        theme.valid?.should be(false)
        theme.errors.should include("Option 'search_placeholder' requires unknown setting 'nonexistent_setting'")
      end

      it "validates multiple requirements" do
        setup_theme_with_options([
          {
            'variable' => 'show_inventory',
            'label' => 'Show inventory',
            'description' => 'Shows inventory count'
          },
          {
            'variable' => 'low_stock_message',
            'label' => 'Low stock message',
            'description' => 'Message for low stock',
            'requires' => [
              'inventory',
              'show_inventory eq true',
              'nonexistent_setting eq true'
            ]
          }
        ])

        theme.valid?.should be(false)
        theme.errors.should include("Option 'low_stock_message' requires unknown setting 'nonexistent_setting'")
      end

      it "allows simple setting requirements without operators" do
        setup_theme_with_options([
          {
            'variable' => 'show_search',
            'label' => 'Show search',
            'description' => 'Shows search field'
          },
          {
            'variable' => 'search_position',
            'label' => 'Search position',
            'description' => 'Position of search field',
            'requires' => ['show_search']
          }
        ])

        theme.valid?.should be(true)
        theme.errors.should be_empty
      end

      it "requires 'requires' to be either a string or array" do
        setup_theme_with_options([
          {
            'variable' => 'invalid_option',
            'label' => 'Invalid option',
            'description' => 'Has invalid requires',
            'requires' => { 'something' => 'wrong' }
          }
        ])

        theme.valid?.should be(false)
        theme.errors.should include("Option 'invalid_option' requires must be string 'inventory' or array of rules")
      end

      it "only allows 'inventory' as a string requires" do
        setup_theme_with_options([
          {
            'variable' => 'invalid_option',
            'label' => 'Invalid option',
            'description' => 'Has invalid requires',
            'requires' => 'not_inventory'
          }
        ])

        theme.valid?.should be(false)
        theme.errors.should include("Option 'invalid_option' requires unknown setting 'not_inventory'")
      end
    end
  end

  def read_file(file_name)
    File.read(File.join(Dugway.source_dir, file_name))
  end
end
