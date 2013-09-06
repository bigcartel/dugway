require 'spec_helper'

describe Dugway::Filters::UrlFilters do
  describe "#product_image_url" do
    let(:product) { Dugway.store.products.first }
    let(:product_image) { Dugway::Drops::ImageDrop.new(product['images'].first) }
    let(:image_url) { product['images'].first['url'] }

    describe "#product_image_url" do
      describe "when image is not missing" do
        it "should show image with default size" do
          template = rendered_template("{{ image | product_image_url }}", 'image' => product_image)
          template.should =~ /max_h-1000\+max_w-1000/
          template.should =~ /#{Regexp.escape(File.basename(image_url))}/
        end

        it "should show a image with custom size" do
          template = rendered_template("{{ image | product_image_url: 'thumb' }}", 'image' => product_image)
          template.should =~ /max_h-75\+max_w-75/
          template.should =~ /#{Regexp.escape(File.basename(image_url))}/
        end

        it "should show image with default size when its random crap" do
          template = rendered_template("{{ image | product_image_url: 'snarble' }}", 'image' => product_image)
          template.should =~ /max_h-1000\+max_w-1000/
          template.should =~ /#{Regexp.escape(File.basename(image_url))}/
        end
      end

      describe "when image is missing" do
        it "should show missing image with default 1000x1000" do
          template = rendered_template("{{ image | product_image_url }}", 'image' => nil)
          template.should =~ /max_h-1000\+max_w-1000/
          template.should =~ /missing\.png/
        end

        it "should show missing image with custom size" do
          template = rendered_template("{{ image | product_image_url: 'thumb' }}", 'image' => nil)
          template.should =~ /max_h-75\+max_w-75/
          template.should =~ /missing\.png/
        end

        it "should show missing image with default 1000x1000 when its random crap" do
          template = rendered_template("{{ image | product_image_url: 'snarble' }}", 'image' => nil)
          template.should =~ /max_h-1000\+max_w-1000/
          template.should =~ /missing\.png/
        end
      end
    end

    describe "#constrain" do
      it 'should constrain the image to the specified size' do
        template = rendered_template("{{ image | product_image_url | constrain: '222', '222' }}", 'image' => product_image)
        template.should =~ /max_h-222\+max_w-222/
      end
    end
  end

  private

  def rendered_template(template, assigns={})
    Liquid::Template.parse(template).render(assigns, :registers => { :currency => Dugway.store.currency })
  end
end
