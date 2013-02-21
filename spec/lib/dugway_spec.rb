require 'spec_helper'

describe Dugway do
  describe ".application" do
    it "returns an application" do
      Dugway.application.should be_present
    end
  end
end
