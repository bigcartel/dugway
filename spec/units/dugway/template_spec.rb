require 'spec_helper'

describe Dugway::Template do
  let(:name) { 'home.html' }
  let(:template) { Dugway::Template.new(name) }
  
  describe "#content" do
    it "returns the content of the file" do
      template.content.should == Dugway.theme.file_content(name)
    end
  end

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
      let(:name) { 'maintenance.html' }
      
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
  
  describe "#render" do
    let(:theme) { Dugway.theme }
    let(:store) { Dugway::Store.new('dugway') }
    let(:request) { Dugway::Request.new({ 'rack.url_scheme' => 'http', 'HTTP_HOST' => 'sexy.dev', 'PATH_INFO' => '/' }) }
    let(:variables) { {} }
    let(:layout) { theme.layout }
    let(:content) { theme.file_content(name) }
    
    describe "when rendering an embedded HTML template" do
      it "calls renders properly with Liquifier" do
        Dugway::Liquifier.any_instance.should_receive(:render).with(content, variables) { content }
        Dugway::Liquifier.any_instance.should_receive(:render).with(layout, variables.update(:page_content => content))
        template.render(request, variables)
      end
    end
    
    describe "when rendering a standalone HTML template" do
      let(:name) { 'maintenance.html' }
      
      it "calls renders properly with Liquifier" do
        Dugway::Liquifier.any_instance.should_receive(:render).with(content, variables)
        template.render(request, variables)
      end
    end
    
    describe "when rendering non-HTML template" do
      let(:name) { 'scripts.js' }
      
      it "doesn't liquify it" do
        Dugway::Liquifier.any_instance.should_not_receive(:render)
        template.render(request, variables).should == content
      end
    end

    describe "when passing variables" do
      let(:variables) { { :errors => ['one', 'two'] } }

      it "calls renders properly with Liquifier" do
        Dugway::Liquifier.any_instance.should_receive(:render).with(content, variables) { content }
        Dugway::Liquifier.any_instance.should_receive(:render).with(layout, variables.update(:page_content => content))
        template.render(request, variables)
      end
    end

    describe "when passing a page variable containing content" do
      let(:page) { store.page('about-us') }
      let(:variables) { { :page => page } }
      let(:content) { page['content'] }

      it "calls renders properly with Liquifier" do
        Dugway::Liquifier.any_instance.should_receive(:render).with(content, variables) { content }
        Dugway::Liquifier.any_instance.should_receive(:render).with(layout, variables.update(:page_content => content))
        template.render(request, variables)
      end
    end
  end
end
