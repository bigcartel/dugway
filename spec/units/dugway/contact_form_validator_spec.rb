require 'spec_helper'
require 'dugway/contact_form_validator'

describe Dugway::ContactFormValidator do

  let(:validator) { described_class.new(params) }

  let(:params) do
    {
      :name => "name",
      :email => "name@example.com",
      :subject => "subject",
      :message => "message",
    }
  end

  describe "#error_message" do
    it "returns an error for a missing name" do
      validator.params[:name] = " "
      assert_required_fields_error
    end

    it "returns an error for a missing email" do
      validator.params[:email] = ""
      assert_required_fields_error
    end

    it "returns an error for a missing subject" do
      validator.params[:subject] = nil
      assert_required_fields_error
    end

    it "returns an error for a missing message" do
      validator.params[:message] = nil
      assert_required_fields_error
    end

    it "returns an error for invalid email format" do
      validator.params[:email] = "foo-at-foo-dot-net"
      expect(validator.error_message).to eq "Invalid email address"
    end

    def assert_required_fields_error
      expect(validator.error_message).to eql "All fields are required"
    end

  end

end
