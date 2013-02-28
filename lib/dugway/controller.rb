module Dugway
  class Controller < Router
    # Home

    get '/' do
      render_text 'Home'
    end

    # Products

    get '/products' do
      render_text 'Products'
    end

    get '/category/:permalink' do |request|
      render_text "Category: #{ request.params.inspect }"
    end

    get '/artist/:permalink' do |request|
      render_text "Artist: #{ request.params.inspect }"
    end

    # Product

    get '/product/:permalink' do |request|
      render_text "Product: #{ request.params.inspect }"
    end

    # Contact form

    get '/contact' do
      render_text 'GET Contact'
    end

    post '/contact' do
      render_text 'POST Contact'
    end

    # Images

    get %r{^/images/.+\.(jpg|jpeg|gif|png)$} do |request|
      Rack::File.new(Dugway.source_dir).call(request.env)
    end
  end
end
