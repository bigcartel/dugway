module Dugway
  class ContactFormValidator

    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def error_message
      if required_fields.any? { |f| params[f].blank? }
        'All fields are required'
      elsif param_does_not_match(:email, email_format)
        'Invalid email address'
      end
    end

    private

    def required_fields
      [ :name, :email, :subject, :message ]
    end

    def email_format
      /^([^@\s]+)@((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})$/
    end

    def param_does_not_match(param_name, regex)
      !(params[param_name.to_sym] =~ regex)
    end

  end
end
