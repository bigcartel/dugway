require 'spec_helper'

feature 'Default pages' do
  scenario 'home page' do
    visit '/'
    expect(page).to have_content('Dugway')
    expect(page).to have_content('My Product')
    expect(page).to have_content('$10.00')
  end

  scenario 'products page' do
    visit '/products'
    expect(page).to have_content('Dugway')
    expect(page).to have_content('Products')
    expect(page).to have_content('My Product')
    expect(page).to have_content('$10.00')
  end

  scenario 'product page' do
    visit '/product/my-product'
    expect(page).to have_content('Dugway')
    expect(page).to have_content('My Product')
    expect(page).to have_content('$10.00')
  end

  scenario 'cart page' do
    visit '/cart'
    expect(page).to have_content('Dugway')
    expect(page).to have_content('Cart')
    expect(page).to have_content('Your cart is empty')
  end

  scenario 'success page' do
    visit '/success'
    expect(page).to have_content('Dugway')
    expect(page).to have_content('Thank You. Your order has been placed.')
  end

  scenario 'contact page' do
    visit '/contact'
    expect(page).to have_content('Dugway')
    expect(page).to have_content('Contact')
    expect(page).to have_content('Your Name:')
  end

  scenario 'maintenance page' do
    visit '/maintenance'
    expect(page).to have_content('Please check back soon.')
  end
end
