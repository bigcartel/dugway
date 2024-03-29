require 'spec_helper'

feature 'Page rendering' do
  scenario 'home.html' do
    visit '/'
    expect(page).to have_content('Dugway') # layout.html
    expect(page).to have_content('My Product')
    expect(page).to have_content('$10.00')
  end

  scenario 'products.html' do
    visit '/products'
    expect(page).to have_content('Dugway') # layout.html
    expect(page).to have_content('Products')
    expect(page).to have_content('My Product')
    expect(page).to have_content('$10.00')
  end

  scenario 'products.html via artist' do
    visit '/artist/artist-one'
    expect(page).to have_content('Dugway') # layout.html
    expect(page).to have_content('Artist One')
    expect(page).to have_content('My Product')
    expect(page).to have_content('$10.00')
  end

  scenario 'products.html via category' do
    visit '/category/tees'
    expect(page).to have_content('Dugway') # layout.html
    expect(page).to have_content('Tees')
    expect(page).to have_content('My Product')
    expect(page).to have_content('$10.00')
  end

  scenario 'product.html' do
    visit '/product/my-product'
    expect(page).to have_content('Dugway') # layout.html
    expect(page).to have_content('My Product')
    expect(page).to have_content('$10.00')
  end

  scenario 'cart.html' do
    visit '/cart'
    expect(page).to have_content('Dugway') # layout.html
    expect(page).to have_content('Cart')
    expect(page).to have_content('Your cart is empty')
  end

  scenario 'contact.html' do
    visit '/contact'
    expect(page).to have_content('Dugway') # layout.html
    expect(page).to have_content('Contact')
    expect(page).to have_content('protected by reCAPTCHA')
  end

  scenario 'maintenance.html' do
    visit '/maintenance'
    expect(page).to have_content('Please check back soon.')
  end

  scenario 'custom page' do
    visit '/about-us'
    expect(page).to have_content('Dugway') # layout.html
    expect(page).to have_content('About Us')
    expect(page).to have_content("We're really cool!")
  end

  scenario 'theme.css' do
    visit '/theme.css'
    expect(page).to have_content('height: 100%;') # one.css
    expect(page).to have_content('color: red;') # two.css.sass
  end

  scenario 'theme.js' do
    visit '/theme.js'
    expect(page).to have_content("console.log('One');") # one.js
    expect(page).to have_content("console.log('Two');") # two.js.coffee
  end
end
