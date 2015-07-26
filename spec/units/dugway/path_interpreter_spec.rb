require 'spec_helper'
require 'dugway/path_interpreter'

describe Dugway::PathInterpreter do
  let(:path) { double 'path' }
  let(:interpreter) { described_class.new(path) }

  it "initializes with arguements" do
    expect(interpreter.path).to eq path
  end

  describe "#call" do
    it "handles non-string paths" do
      expect(described_class.new(/regex/).call).to eql /regex/
    end

    it "handles category, artist, and product type paths" do
      expect(described_class.new("/product/:product(.js)").call).to eq(
        %r{^/product/(?<product>(?-mix:[a-z0-9\-_]+))(?-mix:(\.(?<format>js))?)$}
      )
    end

    it "handles products and cart type paths" do
      expect(described_class.new("/products(.js)").call).to eq(
        %r{^/products(?-mix:(\.(?<format>js))?)$}
      )
    end

    it "handles custom pages" do
      expect(described_class.new("/:custom-page").call).to eq(
        %r{^/(?<custom-page>(?-mix:[a-z0-9\-_]+))$}
      )
    end

    it "handles everything else" do
      expect(described_class.new("/checkout").call).to eq(
        %r{^/checkout$}
      )
    end
  end
end
