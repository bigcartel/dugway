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

  describe "#money" do
    it "should convert a number to currency format" do
      rendered_template("{{ 1234.56 | money }}").should == '1,234.56'
    end

    it "should support the 'sign' format argument" do
      rendered_template("{{ 1234.56 | money: 'sign' }}").should == '<span class="currency_sign">$</span>1,234.56'
    end

    it "should support the 'code' format argument" do
      rendered_template("{{ 1234.56 | money: 'code' }}").should == '1,234.56 <span class="currency_code">USD</span>'
    end

    it "should support the 'sign_and_code' format argument" do
      rendered_template("{{ 1234.56 | money: 'sign_and_code' }}").should == '<span class="currency_sign">$</span>1,234.56 <span class="currency_code">USD</span>'
    end
  end

  describe "#money_with_sign" do
    it "should convert a number to currency format with a sign" do
      rendered_template("{{ 1234.56 | money_with_sign }}").should == '<span class="currency_sign">$</span>1,234.56'
    end
  end

  describe "#money_with_code" do
    it "should convert a number to currency format with a code" do
      rendered_template("{{ 1234.56 | money_with_code }}").should == '1,234.56 <span class="currency_code">USD</span>'
    end
  end

  describe "#money_with_sign_and_code" do
    it "should convert a number to currency format with a sign and code" do
      rendered_template("{{ 1234.56 | money_with_sign_and_code }}").should == '<span class="currency_sign">$</span>1,234.56 <span class="currency_code">USD</span>'
    end
  end

  private

  def rendered_template(template, assigns={})
    Liquid::Template.parse(template).render(assigns, :registers => { :currency => Dugway.store.currency })
  end
end
