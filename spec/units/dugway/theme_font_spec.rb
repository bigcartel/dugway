require 'spec_helper'

describe Dugway::ThemeFont do
  before(:each) do
    # Start fresh each time, so stubs work
    Dugway::ThemeFont.send(:remove_class_variable, :@@source) rescue nil
    Dugway::ThemeFont.send(:remove_class_variable, :@@all) rescue nil
    Dugway::ThemeFont.send(:remove_class_variable, :@@options) rescue nil
    Dugway::ThemeFont.send(:remove_class_variable, :@@google_font_names) rescue nil
  end
  
  describe ".all" do
    it "should return all theme fonts" do
      Dugway::ThemeFont.all.should be_present
    end
    
    it "should be in alphabetical order" do
      Dugway::ThemeFont.all.first.name.should == 'Amaranth'
      Dugway::ThemeFont.all.last.name.should == 'Verdana'
    end
  end
  
  describe ".options" do
    before(:each) do
      Dugway::ThemeFont.stub(:all) {[
        Dugway::ThemeFont.new('One'),
        Dugway::ThemeFont.new('Two'),
        Dugway::ThemeFont.new('Three')
      ]}
    end
    
    it "should return an array of all font names" do
      Dugway::ThemeFont.options.should == ['One', 'Two', 'Three']
    end
  end
  
  describe ".find_by_name" do
    it "should return a font by its name" do
      georgia = Dugway::ThemeFont.find_by_name('Georgia')
      georgia.name.should == 'Georgia'
      georgia.family.should == 'Georgia, "Times New Roman", Times, serif'
      georgia.collection.should == 'default'
    end
    
    it "should return nil if the font doesn't exist" do
      Dugway::ThemeFont.find_by_name('Blah').should be_nil
    end
  end
  
  describe ".find_family_by_name" do
    it "should return the font family by its name" do
      Dugway::ThemeFont.find_family_by_name('Georgia').should == 'Georgia, "Times New Roman", Times, serif'
    end
    
    it "should return the font name if no font is found" do
      Dugway::ThemeFont.find_family_by_name('Blah').should == 'Blah'
    end
  end
  
  describe ".google_font_names" do
    before(:each) do
      Dugway::ThemeFont.stub(:all) {[
        Dugway::ThemeFont.new('One Font', 'One Family', 'google'),
        Dugway::ThemeFont.new('Two', 'Two Family', 'default'),
        Dugway::ThemeFont.new('Three', 'Three Family', 'google')
      ]}
    end
    
    it "returns a sorted array of font names in the google collection" do
      Dugway::ThemeFont.google_font_names.should == ['One Font', 'Three']
    end
  end
  
  describe ".google_font_url_for_fonts" do
    it "should return a url for a given array of font names" do
      Dugway::ThemeFont.google_font_url_for_fonts(['Matt Rules', 'Dude', 'Yeah']).should == "//fonts.googleapis.com/css?family=Matt+Rules|Dude|Yeah"
    end
    
    it "should return a url for a singular font in an array" do
      Dugway::ThemeFont.google_font_url_for_fonts(['Matt Rules']).should == "//fonts.googleapis.com/css?family=Matt+Rules"
    end
  end
  
  describe ".google_font_url_for_all_fonts" do
    before(:each) do
      Dugway::ThemeFont.stub(:all) {[
        Dugway::ThemeFont.new('One Font', 'One Family', 'google'),
        Dugway::ThemeFont.new('Two', 'Two Family', 'default'),
        Dugway::ThemeFont.new('Three', 'Three Family', 'google')
      ]}
    end
    
    it "should return a URL for all Google fonts" do
      Dugway::ThemeFont.google_font_url_for_all_fonts.should == "//fonts.googleapis.com/css?family=One+Font|Three"
    end
  end
  
  describe ".google_font_url_for_theme" do
    let(:fonts) { { :header_font => {}, :body_font => {}, :paragraph_font => {} } }
    
    before(:each) do
      Dugway::Theme.any_instance.stub(:customization) { fonts }
      Dugway::Theme.any_instance.stub(:fonts) { fonts }
      
      Dugway::ThemeFont.stub(:all) {[
        Dugway::ThemeFont.new('One Font', 'One Family', 'google'),
        Dugway::ThemeFont.new('Two', 'Two Family', 'default'),
        Dugway::ThemeFont.new('Three', 'Three Family', 'google')
      ]}
    end

    describe "when it has multiple Google fonts" do
      let(:fonts) { { :header_font => 'One Font', :body_font => 'Two', :paragraph_font => 'Three' } }
      
      it "should return the correct URL" do
        Dugway::ThemeFont.google_font_url_for_theme.should == "//fonts.googleapis.com/css?family=One+Font|Three"
      end
    end

    describe "when it has one Google font" do
      let(:fonts) { { :header_font => 'One Font', :body_font => 'Two' } }
      
      it "should return the correct URL" do
        Dugway::ThemeFont.google_font_url_for_theme.should == "//fonts.googleapis.com/css?family=One+Font"
      end
    end

    describe "when it has no Google fonts" do
      let(:fonts) { { :body_font => 'Two' } }
      
      it "should return the correct URL" do
        Dugway::ThemeFont.google_font_url_for_theme.should be_nil
      end
    end
  end
end
