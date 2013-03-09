require 'spec_helper'

feature 'Shopping' do
  scenario 'buying a product' do
    visit '/'
    expect(page).to have_content('Cart ($0.00)')

    add_product_to_cart
    expect(page).to have_content('Cart ($10.00)')

    click_button 'Checkout'
    expect(page).to have_content('One moment...')

    click_button 'Checkout'
    expect(page).to have_content('Thank You. Your order has been placed.')
    expect(page).to have_content('Cart ($0.00)')
  end

  scenario 'updating a cart' do
    add_product_to_cart
    fill_in 'item_1_qty', :with => 3
    click_button 'Update'
    expect(page).to have_content('Cart ($30.00)')
  end

  scenario 'removing a product' do
    add_product_to_cart
    fill_in 'item_1_qty', :with => 0
    click_button 'Update'
    expect(page).to have_content('Cart ($0.00)')
    expect(page).to have_content('Your cart is empty')
  end

  def add_product_to_cart
    visit '/product/my-product'
    click_button 'Add to Cart'
  end
end
