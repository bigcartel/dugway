class ContactDrop < BaseDrop
  def name
    @params[:name] ||= ''
  end
  
  def email
    @params[:email] ||= ''
  end
  
  def subject
    @params[:subject] ||= ''
  end
  
  def message
    @params[:message] ||= ''
  end
  
  def captcha
    %{<img id="captcha_image" src="http://cache1.bigcartel.com/captcha/e60c0edde94b646a4c2b1dcd6d94c8ded723c849.png" /><input name="captcha_validation" type="hidden" value="e60c0edde94b646a4c2b1dcd6d94c8ded723c849" />}
  end
  
  def sent
    name.present? && email.present? && subject.present? && message.present?
  end  
end
