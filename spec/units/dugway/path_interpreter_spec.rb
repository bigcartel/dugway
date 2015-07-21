require 'spec_helper'
require 'dugway/path_interpreter'

describe Dugway::PathInterpreter do
  let(:path) { double 'path' }
  let(:interpreter) { described_class.new(path) }

  it "initializes with arguements" do
    expect(interpreter.path).to eq path
  end

  describe "#call" do
    context "path is a string" do
      let(:path) { "category/artist/product" }
      it "returns a regex" do
        expect(interpreter.call).to be_instance_of Regexp
      end
    end

    context "path is not a string" do
      it "returns path when path is not a string" do
        expect(interpreter.call).to eq(path)
      end
    end
  end
end
