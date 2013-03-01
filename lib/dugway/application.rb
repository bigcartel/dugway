require 'dugway/controller'

module Dugway
  class Application < Controller
    # Home

    get '/' do
      render_text "Home: #{ page.inspect }"
    end

    # Products

    get '/products(.js)' do
      render_text "Products: #{ params.inspect }"
    end

    get '/category/:category(.js)' do
      if category = store.category(params[:category])
        page['name'] = category['name']
        render_text "Category: #{ page.inspect }"
      else
        render_not_found
      end
    end

    get '/artist/:artist(.js)' do
      if artist = store.artist(params[:artist])
        page['name'] = artist['name']
        render_text "artist page: #{ page.inspect }"
      else
        render_not_found
      end
    end

    # Product

    get '/product/:product(.js)' do
      if product = store.product(params[:product])
        page['name'] = product['name']
        render_text "product page: #{ page.inspect }"
      else
        render_not_found
      end
    end

    # Cart

    get '/cart(.js)' do
      render_text "GET Cart"
    end

    post '/cart(.js)' do
      cart.update(params[:cart])
      render_text "POST Cart: #{ request.params.inspect }"
    end

    # Checkout

    any '/checkout' do
      if cart.empty?
        # render_text 'Must have at least one product to checkout'
        redirect_to '/cart'
      else
        render_text "Checkout"
      end
    end

    # Success

    get '/success' do
      render_text "Success"
    end

    post '/success' do
      sleep(3) # Give the checkout page time
      cart.reset
      render_text "POST Success"
    end

    # Contact

    any '/contact' do
      render_text 'GET Contact'
    end

    # Maintenance

    get '/maintenance' do
      render_text "Maintenance"
    end

    # Custom page

    get '/:permalink' do
      render_text "Custom page: #{ page.inspect }"
    end

    # Assets

    get '/styles.css' do
      render_text 'Styles'
    end

    get '/scripts.js' do
      render_text 'Scripts'
    end

    get %r{^/images/.+\.(jpg|jpeg|gif|png)$} do
      Rack::File.new(Dugway.source_dir).call(request.env)
    end
  end
end
