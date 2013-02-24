require 'spec_helper'

describe Dugway::Template do
  let(:name) { 'home.html' }
  let(:content) { 'Hi there.' }
  let(:template) { Dugway::Template.new(name, content) }
  
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
  
  describe "#html?" do
    describe "when it's an HTML template" do
      it "returns true" do
        template.html?.should be_true
      end
    end
    
    describe "when it's not an HTML template" do
      let(:name) { 'styles.css' }
      
      it "returns false" do
        template.html?.should be_false
      end
    end
  end
  
  describe "#standalone_html?" do
    describe "for HTML pages with head_content" do
      let(:content) { 'Hi {{ head_content }} there.' }
      
      it "returns true" do
        template.standalone_html?.should be_true
      end
    end
    
    describe "for HTML pages without head_content" do
      it "returns false" do
        template.standalone_html?.should be_false
      end
    end
    
    describe "for non-HTML" do
      let(:name) { 'styles.css' }
      
      it "returns false" do
        template.standalone_html?.should be_false
      end
    end
  end
  
  describe "#success_page?" do
    describe "when it's the success.html template" do
      let(:name) { 'success.html' }
      
      it "returns true" do
        template.success_page?.should be_true
      end
    end
    
    describe "when it's not the success.html template" do
      it "returns false" do
        template.success_page?.should be_false
      end
    end
  end
  
  describe "#render" do
    let(:theme) { fake_theme }
    let(:store) { Dugway::Store.new('dugway') }
    let(:request) { Dugway::Request.new({ 'rack.url_scheme' => 'http', 'HTTP_HOST' => 'sexy.dev', 'PATH_INFO' => '/' }) }
    let(:layout) { '<html><head>{{ head_content }}</head><body>{{ page_content }}</body></html>' }
    
    before(:each) do
      theme.stub(:layout) { layout }
    end
    
    describe "when rendering an embedded HTML template" do
      it "calls renders properly with Liquifier" do
        Dugway::Liquifier.any_instance.should_receive(:render).with(content) { content }
        Dugway::Liquifier.any_instance.should_receive(:render).with(layout, 'page_content' => content)
        template.render(theme, store, request)
      end
    end
    
    describe "when rendering a standalone HTML template" do
      let(:name) { 'maintenance.html' }
      let(:content) { 'Hi {{ head_content }} there.' }
      
      it "calls renders properly with Liquifier" do
        Dugway::Liquifier.any_instance.should_receive(:render).with(content)
        template.render(theme, store, request)
      end
    end
    
    describe "when rendering non-HTML template" do
      let(:name) { 'scripts.js' }
      
      it "doesn't liquify it" do
        Dugway::Liquifier.any_instance.should_not_receive(:render)
        template.render(theme, store, request).should == content
      end
    end
    
    describe "when posting to the success page" do
      let(:name) { 'success.html' }
      
      before(:each) do
        request.stub(:post?) { true }
        Dugway::Liquifier.any_instance.stub(:render).with(content) { content }
        Dugway::Liquifier.any_instance.stub(:render).with(layout, 'page_content' => content)
      end
      
      it "sleeps for 3 seconds to give the 'One moment...' time" do
        template.should_receive(:sleep).with(3)
        template.render(theme, store, request)
      end
    end
  end
end
