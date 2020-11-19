require 'spec_helper'

describe Dugway::Drops::PagesDrop do
  let(:pages) do
    Dugway::Drops::PagesDrop.new(
      Dugway.store.pages.map do |p|
        case p["permalink"]
        when "cart"
          Dugway::Drops::CartDrop.new(p)
        else
          Dugway::Drops::PageDrop.new(p)
        end
      end
    )
  end

  describe "#all" do
    it "should return an array of all pages" do
      all = pages.all
      all.should be_an_instance_of(Array)
      all.size.should == 1

      page = all.first
      page.should be_an_instance_of(Dugway::Drops::PageDrop)
      page.name.should == 'About Us'
    end
  end

  describe "#cart" do
    it "returns the cart drop instead of the cart class instance" do
      cart = pages.cart
      cart.should be_an_instance_of(Dugway::Drops::CartDrop)
      cart.name.should == 'Cart'
    end
  end

  describe "#permalink" do
    it "should return the page by permalink" do
      page = pages.contact
      page.should be_an_instance_of(Dugway::Drops::PageDrop)
      page.name.should == 'Contact'
    end

    it "should return the nil for an invalid permalink" do
      pages.blah.should be_nil
    end
  end

  private

  def rendered_template(template, assigns={}, registers={})
    Liquid::Template.parse(template).render(assigns, :registers => { :currency => Dugway.store.currency }.merge(registers))
  end
end
