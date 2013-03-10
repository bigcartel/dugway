require 'spec_helper'

describe Dugway::Drops::CategoriesDrop do
  let(:categories) { Dugway::Drops::CategoriesDrop.new(Dugway.store.categories.map { |c| Dugway::Drops::CategoryDrop.new(c) }) }

  describe "#all" do
    it "should return an array of all categories" do
      all = categories.all
      all.should be_an_instance_of(Array)
      all.size.should == 4

      category = all.first
      category.should be_an_instance_of(Dugway::Drops::CategoryDrop)
      category.name.should == 'CDs'
    end
  end

  describe "#active" do
    it "should return an array of all active categories" do
      active = categories.active
      active.should be_an_instance_of(Array)
      active.size.should == 2

      category = active.first
      category.should be_an_instance_of(Dugway::Drops::CategoryDrop)
      category.name.should == 'Prints'
    end
  end

  describe "#permalink" do
    it "should return the category by permalink" do
      category = categories.prints
      category.should be_an_instance_of(Dugway::Drops::CategoryDrop)
      category.name.should == 'Prints'
    end

    it "should return the nil for an invalid permalink" do
      categories.blah.should be_nil
    end
  end
end
