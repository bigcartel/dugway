module Dugway
  module Drops
    class ContactDrop < BaseDrop
      def name
        params[:name] ||= ''
      end

      def email
        params[:email] ||= ''
      end

      def subject
        params[:subject] ||= ''
      end

      def message
        params[:message] ||= ''
      end

      def captcha
        %{<img id="captcha_image" src="https://s3.amazonaws.com/bigcartel/captcha/28e3d1288cbc70c0cd1a2d10845f8e11e1a90d14.png">}
      end

      def recaptcha
        @recaptcha ||= begin
          html = "This site is protected by reCAPTCHA and the Google "
          html += '<a href="https://policies.google.com/privacy">Privacy Policy</a> and '
          html += '<a href="https://policies.google.com/terms">Terms of Service</a> apply.'
          html
        end
      end

      def sent
        request.path == '/contact' && request.post? && errors.blank?
      end
    end
  end
end
