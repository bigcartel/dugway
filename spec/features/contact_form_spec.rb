require 'spec_helper'

feature 'Contact form' do
  scenario 'submitting the form' do
    submit_contact_form
    expect(page).to have_content('Your message has been sent')
  end

  scenario 'with a missing field' do
    submit_contact_form(:name => '')
    expect(page).to have_content('All fields are required')
  end

  scenario 'with an invalid email' do
    submit_contact_form(:email => 'blah')
    expect(page).to have_content('Invalid email address')
  end

  scenario 'with an invalid captcha' do
    submit_contact_form(:captcha => 'blah')
    expect(page).to have_content('Spam check was incorrect')
  end

  def submit_contact_form(fields={})
    fields.reverse_merge!(
      :name => 'Joe',
      :email => 'joe@example.com',
      :subject => 'Testing',
      :message => 'Hi there',
      :captcha => 'rQ9pC'
    )

    visit '/contact'

    fill_in 'Name', :with => fields[:name]
    fill_in 'Email', :with => fields[:email]
    fill_in 'Subject', :with => fields[:subject]
    fill_in 'Message', :with => fields[:message]
    fill_in 'Spam check', :with => fields[:captcha]

    click_button 'Send'
  end
end
