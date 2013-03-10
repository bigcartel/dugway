require 'spec_helper'

describe Dugway::Drops::ArtistsDrop do
  let(:artists) { Dugway::Drops::ArtistsDrop.new(Dugway.store.artists.map { |a| Dugway::Drops::ArtistDrop.new(a) }) }

  describe "#all" do
    it "should return an array of all artists" do
      all = artists.all
      all.should be_an_instance_of(Array)
      all.size.should == 3

      artist = all.first
      artist.should be_an_instance_of(Dugway::Drops::ArtistDrop)
      artist.name.should == 'Artist One'
    end
  end

  describe "#active" do
    it "should return an array of all active artists" do
      active = artists.active
      active.should be_an_instance_of(Array)
      active.size.should == 2

      artist = active.first
      artist.should be_an_instance_of(Dugway::Drops::ArtistDrop)
      artist.name.should == 'Artist One'
    end
  end

  describe "#permalink" do
    it "should return the artist by permalink" do
      artist = artists.threezer
      artist.should be_an_instance_of(Dugway::Drops::ArtistDrop)
      artist.name.should == 'Threezer'
    end

    it "should return the nil for an invalid permalink" do
      artists.blah.should be_nil
    end
  end
end
