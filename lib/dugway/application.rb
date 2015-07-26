require 'dugway/controller'

module Dugway
  class Application < Controller

    get '/' do
      render_page
    end

    get '/products(.js)' do
      if request.html?
        render_page
      elsif request.js?
        render_json(store.products)
      end
    end

    get '/category/:category(.js)' do
      render_not_found unless category = store.category(params[:category])
      render_artist_category_response(category, :category)
    end

    get '/artist/:artist(.js)' do
      render_not_found unless artist = store.artist(params[:artist])
      render_artist_category_response(artist, :artist)
    end

    get '/product/:product(.js)' do
      render_not_found unless product = store.product(params[:product])
      if request.html?
        set_page_name_and_render_page(product, :product)
      elsif request.js?
        render_json(product)
      end
    end

    any '/cart(.js)' do
      if cart_params = params[:cart].try(:with_indifferent_access)
        cart.update(cart_params)
      end

      if params[:checkout]
        redirect_to('/checkout')
      else
        if request.html?
          render_page
        elsif request.js?
          render_json(cart)
        end
      end
    end

    any '/checkout' do
      if cart.empty?
        error('Must have at least one product to checkout')
        redirect_to('/cart')
      else
        render_page
      end
    end

    get '/success' do
      render_page
    end

    post '/success' do
      sleep(3) # Give the checkout page time
      cart.reset
      render_page
    end

    get '/contact' do
      render_page
    end

    post '/contact' do
      if [ :name, :email, :subject, :message, :captcha ].any? { |f| params[f].blank? }
        error('All fields are required')
      elsif !(params[:email] =~ /^([^@\s]+)@((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})$/)
        error('Invalid email address')
      elsif !(params[:captcha] =~ /^rQ9pC$/i)
        error('Spam check was incorrect')
      end

      render_page
    end

    get '/maintenance' do
      render_page
    end

    get '/:permalink' do
      render_page
    end

    get '/theme.css' do
      render_file('theme.css')
    end

    get '/theme.js' do
      render_file('theme.js')
    end

    get %r{^/images|fonts/.+$} do
      Rack::File.new(Dugway.source_dir).call(request.env)
    end

    private

    def self.render_artist_category_response(object, type)
      if request.html?
        set_page_name_and_render_page(object, type)
      elsif request.js?
        render_json(store.send("#{type}_products", params[type]))
      end
    end

    def self.set_page_name_and_render_page(object, type)
      page['name'] = object['name']
      render_page(type => object)
    end

  end
end
