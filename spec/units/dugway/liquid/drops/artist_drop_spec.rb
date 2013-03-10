require 'spec_helper'

describe Dugway::Drops::ArtistDrop do
  let(:artist) { Dugway::Drops::ArtistDrop.new(Dugway.store.artists.first) }

  describe "#id" do
    it "should return the artist's id" do
      artist.id.should == 176141
    end
  end

  describe "#name" do
    it "should return the artist's name" do
      artist.name.should == 'Artist One'
    end
  end

  describe "#permalink" do
    it "should return the artist's permalink" do
      artist.permalink.should == 'artist-one'
    end
  end

  describe "#url" do
    it "should return the artist's url" do
      artist.url.should == '/artist/artist-one'
    end
  end

  describe "#products" do
    it "should return the artist's products" do
      products = artist.products
      products.should be_an_instance_of(Array)

      product = products.first
      product.should be_an_instance_of(Dugway::Drops::ProductDrop)
      product.name.should == 'My Product'
    end
  end
end
