require 'spec_helper'

describe Dugway::Request do
  let(:path) { '/path/to/something' }
  let(:params) { {} }

  let(:env) {
    Rack::MockRequest::DEFAULT_ENV.update({
    'PATH_INFO' => path.split('?').first,
    'QUERY_STRING' => path.split('?').last
  })}

  let(:request) { Dugway::Request.new(env) }

  before(:each) do
    request.stub(:params) { params }
  end

  describe "#page_permalink" do
    describe "on the home page" do
      let(:path) { '/' }

      it "returns the correct page_permalink" do
        request.page_permalink.should == 'home'
      end
    end

    describe "on the products page" do
      let(:path) { '/products' }

      it "returns the correct page_permalink" do
        request.page_permalink.should == 'products'
      end
    end

    describe "on the products page with params" do
      let(:path) { '/products?search=test' }

      it "returns the correct page_permalink" do
        request.page_permalink.should == 'products'
      end
    end

    describe "on the categories page" do
      let(:path) { '/category/tees' }

      it "returns the correct page_permalink" do
        request.page_permalink.should == 'products'
      end
    end

    describe "on the artists page" do
      let(:path) { '/artist/beatles' }

      it "returns the correct page_permalink" do
        request.page_permalink.should == 'products'
      end
    end

    describe "on the product page" do
      let(:path) { '/product/my-thing' }

      it "returns the correct page_permalink" do
        request.page_permalink.should == 'product'
      end
    end

    describe "on the a known page" do
      let(:path) { '/cart' }

      it "returns the correct page_permalink" do
        request.page_permalink.should == 'cart'
      end
    end

    describe "on the a custom page" do
      let(:path) { '/about-us' }

      it "returns the correct page_permalink" do
        request.page_permalink.should == 'about-us'
      end
    end
  end

  describe "#extension" do
    describe "on HTML with no extension" do
      let(:path) { '/cart' }

      it "returns the correct extension" do
        request.extension.should == '.html'
      end
    end

    describe "on HTML with an extension" do
      let(:path) { '/cart.html' }

      it "returns the correct extension" do
        request.extension.should == '.html'
      end
    end

    describe "on CSS" do
      let(:path) { '/theme.css' }

      it "returns the correct extension" do
        request.extension.should == '.css'
      end
    end

    describe "on JS" do
      let(:path) { '/theme.js' }

      it "returns the correct extension" do
        request.extension.should == '.js'
      end
    end
  end

  describe "#format" do
    describe "when format is in the params" do
      let(:params) { { :format => 'js' }}

      it "should return the params format" do
        request.format.should == 'js'
      end
    end

    describe "when format is not in the params" do
      describe "and there is no extension in the path" do
        let(:path) { '/cart' }

        it "should return html" do
          request.format.should == 'html'
        end
      end

      describe "and there is an extension in the path" do
        let(:path) { '/theme.css' }

        it "should return the extension" do
          request.format.should == 'css'
        end
      end
    end
  end

  describe "#html?" do
    describe "on HTML with no extension" do
      let(:path) { '/cart' }

      it "returns true" do
        request.html?.should be_true
      end
    end

    describe "on HTML with an extension" do
      let(:path) { '/cart.html' }

      it "returns true" do
        request.html?.should be_true
      end
    end

    describe "on CSS" do
      let(:path) { '/theme.css' }

      it "returns false" do
        request.html?.should be_false
      end
    end

    describe "on JS" do
      let(:path) { '/theme.js' }

      it "returns false" do
        request.html?.should be_false
      end
    end
  end

  describe "#js?" do
    describe "on JS" do
      let(:path) { '/products.js' }

      it "returns true" do
        request.js?.should be_true
      end
    end

    describe "on no extension" do
      let(:path) { '/cart' }

      it "returns false" do
        request.js?.should be_false
      end
    end

    describe "on non-JS extension" do
      let(:path) { '/cart.html' }

      it "returns false" do
        request.js?.should be_false
      end
    end
  end
end
