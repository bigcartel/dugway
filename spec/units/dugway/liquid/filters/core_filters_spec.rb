require 'spec_helper'

describe Dugway::Filters::CoreFilters do
  describe "#pluralize" do
    it "should pluralize with a count of 2 using the inflector" do
      ActiveSupport.const_defined?(:Inflector).should == true
      rendered_template("{{ 2 | pluralize: 'foo' }}").should == '2 foos'
      rendered_template("{{ 2 | pluralize: 'box' }}").should == '2 boxes'
    end

    it "should pluralize using a custom plural with a count of 2" do
      rendered_template("{{ 2 | pluralize: 'foo', 'fooies' }}").should == '2 fooies'
    end

    it "should not pluralize with a count of 1" do
      rendered_template("{{ 1 | pluralize: 'foo' }}").should == '1 foo'
    end

    it "should add an s with no plural or Inflector defined" do
      ActiveSupport.stub(:const_defined?).with(:Inflector) { false }
      rendered_template("{{ 2 | pluralize: 'foo' }}").should == '2 foos'
      ActiveSupport.stub(:const_defined?).with(:Inflector) { false }
      rendered_template("{{ 2 | pluralize: 'box' }}").should == '2 boxs'
    end
  end

  private

  def rendered_template(template, assigns={})
    Liquid::Template.parse(template).render(assigns)
  end
end
