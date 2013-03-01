require 'dugway/controller'

module Dugway
  class Application < Controller
    # Home

    get '/' do
      render_page
    end

    # Products

    get '/products(.js)' do
      if request.html?
        render_page
      elsif request.js?
        render_json store.products
      end
    end

    get '/category/:category(.js)' do
      if category = store.category(params[:category])
        if request.html?
          page['name'] = category['name']
          render_page(:category => category)
        elsif request.js?
          render_json store.category_products(category['permalink'])
        end
      else
        render_not_found
      end
    end

    get '/artist/:artist(.js)' do
      if artist = store.artist(params[:artist])
        if request.html?
          page['name'] = artist['name']
          render_page(:artist => artist)
        elsif request.js?
          render_json store.artist_products(artist['permalink'])
        end
      else
        render_not_found
      end
    end

    # Product

    get '/product/:product(.js)' do
      if product = store.product(params[:product])
        if request.html?
          page['name'] = product['name']
          render_page(:product => product)
        elsif request.js?
          render_json product
        end
      else
        render_not_found
      end
    end

    # Cart

    any '/cart(.js)' do
      if cart_params = params[:cart].try(:with_indifferent_access)
        cart.update(cart_params)
      end

      if params[:checkout]
        redirect_to '/checkout'
      else
        if request.html?
          render_page
        elsif request.js?
          render_json cart
        end
      end
    end

    # Checkout

    any '/checkout' do
      if cart.empty?
        error 'Must have at least one product to checkout'
        redirect_to '/cart'
      else
        render_page
      end
    end

    # Success

    get '/success' do
      render_page
    end

    post '/success' do
      sleep(3) # Give the checkout page time
      cart.reset
      render_page
    end

    # Contact

    any '/contact' do
      render_page
    end

    # Maintenance

    get '/maintenance' do
      render_page
    end

    # Custom page

    get '/:permalink' do
      render_page
    end

    # Assets

    get '/styles.css' do
      render_file 'styles.css'
    end

    get '/scripts.js' do
      render_file 'scripts.js'
    end

    get %r{^/images/.+\.(jpg|jpeg|gif|png)$} do
      Rack::File.new(Dugway.source_dir).call(request.env)
    end
  end
end
