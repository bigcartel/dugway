require 'spec_helper'

describe Dugway::Request do
  let(:path) { '/path/to/something' }
  
  let(:env) {{
    'PATH_INFO' => path.split('?').first,
    'QUERY_STRING' => path.split('?').last
  }}
  
  let(:request) { Dugway::Request.new(env) }
  
  describe "#file_name" do
    describe "on HTML with an extension" do
      let(:path) { '/cart.html' }
      
      it "returns the file name" do
        request.file_name.should == 'cart.html'
      end
    end
    
    describe "on HTML without an extension" do
      let(:path) { '/cart' }
      
      it "returns the file name" do
        request.file_name.should == 'cart.html'
      end
    end
    
    describe "on non-HTML" do
      let(:path) { '/styles.css' }
      
      it "returns the file name" do
        request.file_name.should == 'styles.css'
      end
    end
  end
  
  describe "#permalink" do
    describe "on the home page" do
      let(:path) { '/' }
      
      it "returns the correct permalink" do
        request.permalink.should == 'home'
      end
    end
    
    describe "on the products page" do
      let(:path) { '/products' }
      
      it "returns the correct permalink" do
        request.permalink.should == 'products'
      end
    end
    
    describe "on the products page with params" do
      let(:path) { '/products?search=test' }
      
      it "returns the correct permalink" do
        request.permalink.should == 'products'
      end
    end
    
    describe "on the categories page" do
      let(:path) { '/category/tees' }
      
      it "returns the correct permalink" do
        request.permalink.should == 'products'
      end
    end
    
    describe "on the artists page" do
      let(:path) { '/artist/beatles' }
      
      it "returns the correct permalink" do
        request.permalink.should == 'products'
      end
    end
    
    describe "on the product page" do
      let(:path) { '/product/my-thing' }
      
      it "returns the correct permalink" do
        request.permalink.should == 'product'
      end
    end
    
    describe "on the a known page" do
      let(:path) { '/cart' }
      
      it "returns the correct permalink" do
        request.permalink.should == 'cart'
      end
    end
    
    describe "on the a custom page" do
      let(:path) { '/about-us' }
      
      it "returns the correct permalink" do
        request.permalink.should == 'about-us'
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
      let(:path) { '/styles.css' }
      
      it "returns the correct extension" do
        request.extension.should == '.css'
      end
    end
    
    describe "on JS" do
      let(:path) { '/scripts.js' }
      
      it "returns the correct extension" do
        request.extension.should == '.js'
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
      let(:path) { '/styles.css' }
      
      it "returns false" do
        request.html?.should be_false
      end
    end
    
    describe "on JS" do
      let(:path) { '/scripts.js' }
      
      it "returns false" do
        request.html?.should be_false
      end
    end
  end
  
  describe "#image?" do
    describe "on JPGs" do
      let(:path) { '/images/image.jpg' }
      
      it "returns true" do
        request.image?.should be_true
      end
    end
    
    describe "on JPEGs" do
      let(:path) { '/images/image.jpeg' }
      
      it "returns true" do
        request.image?.should be_true
      end
    end
    
    describe "on GIFs" do
      let(:path) { '/images/image.gif' }
      
      it "returns true" do
        request.image?.should be_true
      end
    end
    
    describe "on PNGs" do
      let(:path) { '/images/image.png' }
      
      it "returns true" do
        request.image?.should be_true
      end
    end
    
    describe "on images not in the 'images' directory" do
      let(:path) { '/other/image.png' }
      
      it "returns false" do
        request.image?.should be_false
      end
    end
    
    describe "on non-images" do
      let(:path) { '/cart' }
      
      it "returns false" do
        request.image?.should be_false
      end
    end
  end
  
  describe "#custom_page?" do
    describe "on a custom page" do
      let(:path) { '/about-us' }
      
      it "returns true" do
        request.custom_page?.should be_true
      end
    end
    
    describe "on a theme page" do
      let(:path) { '/cart' }
      
      it "returns false" do
        request.custom_page?.should be_false
      end
    end
    
    describe "on non-HTML" do
      let(:path) { '/styles.css' }
      
      it "returns false" do
        request.custom_page?.should be_false
      end
    end
  end
  
  describe "#product_permalink" do
    describe "on a product page" do
      let(:path) { '/product/my-tee' }
      
      it "returns the product permalink" do
        request.product_permalink.should == 'my-tee'
      end
    end
    
    describe "on a non-product page" do
      let(:path) { '/cart' }
      
      it "returns nil" do
        request.product_permalink.should be_nil
      end
    end
  end
  
  describe "#category_permalink" do
    describe "on a category page" do
      let(:path) { '/category/tees' }
      
      it "returns the category permalink" do
        request.category_permalink.should == 'tees'
      end
    end
    
    describe "on a non-category page" do
      let(:path) { '/cart' }
      
      it "returns nil" do
        request.category_permalink.should be_nil
      end
    end
  end
  
  describe "#artist_permalink" do
    describe "on an artist page" do
      let(:path) { '/artist/beatles' }
      
      it "returns the artist permalink" do
        request.artist_permalink.should == 'beatles'
      end
    end
    
    describe "on a non-artist page" do
      let(:path) { '/cart' }
      
      it "returns nil" do
        request.artist_permalink.should be_nil
      end
    end
  end
end
