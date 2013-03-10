require 'spec_helper'

describe Dugway::Drops::ContactDrop do
  let(:params) {{
    :name => 'Joe',
    :email => 'joe@example.com',
    :subject => 'Testing',
    :message => 'Hi there',
    :captcha => 'rQ9pC'
  }}

  let(:env) {
    Rack::MockRequest::DEFAULT_ENV.update({
    'PATH_INFO' => '/contact'
  })}
  
  let(:request) { Dugway::Request.new(env) }

  let(:errors) {
    []
  }

  let(:contact) {
    Dugway::Drops::ContactDrop.new.tap { |drop|
      drop.context = Liquid::Context.new([{}, { 'errors' => errors }], {}, { :params => params, :errors => errors, :request => request })
    }
  }

  describe "#name" do
    it "should return the name param" do
      contact.name.should == params[:name]
    end

    describe "when the name param is blank" do
      before(:each) do
        params.merge!(:name => nil)
      end

      it "should return an empty string" do
        contact.name.should == ''
      end
    end
  end

  describe "#email" do
    it "should return the email param" do
      contact.email.should == params[:email]
    end

    describe "when the email param is blank" do
      before(:each) do
        params.merge!(:email => nil)
      end

      it "should return an empty string" do
        contact.email.should == ''
      end
    end
  end

  describe "#subject" do
    it "should return the subject param" do
      contact.subject.should == params[:subject]
    end

    describe "when the subject param is blank" do
      before(:each) do
        params.merge!(:subject => nil)
      end

      it "should return an empty string" do
        contact.subject.should == ''
      end
    end
  end

  describe "#message" do
    it "should return the message param" do
      contact.message.should == params[:message]
    end

    describe "when the message param is blank" do
      before(:each) do
        params.merge!(:message => nil)
      end

      it "should return an empty string" do
        contact.message.should == ''
      end
    end
  end

  describe "#captcha" do
    it "should return a captcha image" do
      contact.captcha.should == %{<img id="captcha_image" src="https://s3.amazonaws.com/bigcartel/captcha/28e3d1288cbc70c0cd1a2d10845f8e11e1a90d14.png">}
    end
  end

  describe "#sent" do
    it "should return false before the form has been sent" do
      contact.sent.should be(false)
    end

    it "should return false when not on the contact page" do
      request.stub(:path) { '/blah' }
      request.stub(:post?) { true }
      contact.sent.should be(false)
    end

    describe "when there are errors" do
      let(:errors) { ['There was a problem'] }

      it "should return false" do
        request.stub(:post?) { true }
        contact.sent.should be(false)
      end
    end

    it "should return true when the form has been sent" do
      request.stub(:post?) { true }
      contact.sent.should be(true)
    end
  end
end
