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
        %{<img id="captcha_image" src="http://cache1.bigcartel.com/captcha/e60c0edde94b646a4c2b1dcd6d94c8ded723c849.png">}
      end

      def sent
        if request.post?
          if name.blank? || email.blank? || subject.blank? || message.blank?
            error('All fields are required')
            false
          elsif !(email =~ /^([^@\s]+)@((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})$/)
            error('Invalid email address')
            false
          elsif params[:captcha].blank?
            error('Spam check was incorrect')
            false
          else
            true
          end
        else
          false
        end
      end  
    end
  end
end
