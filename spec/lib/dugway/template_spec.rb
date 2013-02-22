require 'spec_helper'

describe Dugway::Template do
  let(:name) { 'home.html' }
  let(:content) { 'Hi there.' }
  let(:liquify) { true }
  let(:template) { Dugway::Template.new(name, content, liquify) }
  
  describe "#content_type" do
    describe "for HTML" do
      it "returns the proper content type" do
        template.content_type.should == 'text/html'
      end
    end
    
    describe "for CSS" do
      let(:name) { 'styles.css' }
      
      it "returns the proper content type" do
        template.content_type.should == 'text/css'
      end
    end
    
    describe "for JS" do
      let(:name) { 'scripts.js' }
      
      it "returns the proper content type" do
        template.content_type.should == 'application/javascript'
      end
    end
  end
  
  describe "#extension" do
    describe "for HTML" do
      it "returns the proper extension" do
        template.extension.should == '.html'
      end
    end
    
    describe "for CSS" do
      let(:name) { 'styles.css' }
      
      it "returns the proper extension" do
        template.extension.should == '.css'
      end
    end
    
    describe "for JS" do
      let(:name) { 'scripts.js' }
      
      it "returns the proper extension" do
        template.extension.should == '.js'
      end
    end
  end
  
  describe "#liquify?" do
    describe "when @liquify is true" do
      it "returns true" do
        template.liquify?.should be_true
      end
    end
    
    describe "when @liquify is false" do
      let(:liquify) { false }
      
      it "returns false" do
        template.liquify?.should be_false
      end
    end
  end
  
  describe "#standalone?" do
    describe "for CSS" do
      let(:name) { 'styles.css' }
      
      it "returns true" do
        template.standalone?.should be_true
      end
    end
    
    describe "for JS" do
      let(:name) { 'scripts.js' }
      
      it "returns true" do
        template.standalone?.should be_true
      end
    end
    
    describe "for HTML pages with head_content" do
      let(:content) { 'Hi {{ head_content }} there.' }
      
      it "returns true" do
        template.standalone?.should be_true
      end
    end
    
    describe "for HTML pages without head_content" do
      it "returns false" do
        template.standalone?.should be_false
      end
    end
  end
  
  describe "#styles?" do
    describe "when it's the styles.css template" do
      let(:name) { 'styles.css' }
      
      it "returns true" do
        template.styles?.should be_true
      end
    end
    
    describe "when it's not the styles.css template" do
      it "returns false" do
        template.styles?.should be_false
      end
    end
  end
  
  describe "#render" do
    let(:theme) { Dugway::Theme.new }
    let(:store) { Dugway::Store.new('dugway') }
    let(:request) { Dugway::Request.new({ 'rack.url_scheme' => 'http', 'HTTP_HOST' => 'sexy.dev', 'PATH_INFO' => '/' }) }
    let(:layout) { '<html><head>{{ head_content }}</head><body>{{ page_content }}</body></html>' }
    
    before(:each) do
      theme.stub(:layout) { layout }
    end
    
    describe "when rendering an embedded template" do
      it "calls renders properly with Liquifier" do
        Dugway::Liquifier.any_instance.should_receive(:render).with(content, {}, false) { content }
        Dugway::Liquifier.any_instance.should_receive(:render).with(layout, 'page_content' => content)
        template.render(theme, store, request)
      end
    end
    
    describe "when rendering a standalone template" do
      let(:name) { 'maintenance.html' }
      let(:content) { 'Hi {{ head_content }} there.' }
      
      it "calls renders properly with Liquifier" do
        Dugway::Liquifier.any_instance.should_receive(:render).with(content, {}, false)
        template.render(theme, store, request)
      end
    end
    
    describe "when rendering the styles.css template" do
      let(:name) { 'styles.css' }
      
      it "calls renders properly with Liquifier" do
        Dugway::Liquifier.any_instance.should_receive(:render).with(content, {}, true)
        template.render(theme, store, request)
      end
    end
    
    describe "when rendering non-liquify template" do
      let(:name) { 'scripts.js' }
      let(:liquify) { false }
      
      it "doesn't liquify it" do
        Dugway::Liquifier.any_instance.should_not_receive(:render)
        template.render(theme, store, request).should == content
      end
    end
  end
end
