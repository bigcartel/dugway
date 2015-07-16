require 'httparty'

module Dugway
  class Store
    include HTTParty

    format :json
    default_timeout 5
    headers 'User-Agent' => "Dugway #{ Dugway::VERSION }"

    def initialize(subdomain)
      self.class.base_uri "http://api.bigcartel.com/#{ subdomain }"
    end

    def account
      @account ||= get('/store.json')
    end

    def theme_pages
      [
        { 'name' => 'Home', 'permalink' => 'home', 'url' => '/', 'category' => 'theme' },
        { 'name' => 'Products', 'permalink' => 'products', 'url' => '/products', 'category' => 'theme' },
        { 'name' => 'Product', 'permalink' => 'product', 'url' => '/product', 'category' => 'theme' },
        { 'name' => 'Cart', 'permalink' => 'cart', 'url' => '/cart', 'category' => 'theme' },
        { 'name' => 'Checkout', 'permalink' => 'checkout', 'url' => '/checkout', 'category' => 'theme' },
        { 'name' => 'Success', 'permalink' => 'success', 'url' => '/success', 'category' => 'theme' },
        { 'name' => 'Contact', 'permalink' => 'contact', 'url' => '/contact', 'category' => 'theme' },
        { 'name' => 'Maintenance', 'permalink' => 'maintenance', 'url' => '/maintenance', 'category' => 'theme' }
      ]
    end

    def custom_pages
      @custom_pages ||= begin
        custom_pages = account.has_key?('pages') ? account['pages'] : []
        custom_pages = custom_pages.map { |page| get("/page/#{ page['permalink'] }.json") }
      end
    end

    def pages
      @pages ||= theme_pages + custom_pages
    end

    def page(permalink)
      lookup(permalink, pages)
    end

    def categories
      account.has_key?('categories') ? account['categories'] : []
    end

    def category(permalink)
      lookup(permalink, categories)
    end

    def category_products(permalink)
      lookup_products(permalink, 'categories')
    end

    def artists
      account.has_key?('artists') ? account['artists'] : []
    end

    def artist(permalink)
      lookup(permalink, artists)
    end

    def artist_products(permalink)
      lookup_products(permalink, 'artists')
    end

    def products
      @products ||= get('/products.json')
      Marshal.load(Marshal.dump(@products)) # Hack to avoid data munging elsewhere?
    end

    def product(permalink)
      lookup(permalink, products)
    end

    def product_and_option(option_id)
      products.each do |product|
        product['options'].each do |option|
          if option['id'] == option_id
            return product, option
          end
        end
      end

      nil
    end

    def previous_product(permalink)
      products.each_with_index do |product, index|
        if product['permalink'] == permalink && index > 0 && previous_product = products[index - 1]
          return previous_product
        end
      end

      nil
    end

    def next_product(permalink)
      products.each_with_index do |product, index|
        if product['permalink'] == permalink && (index + 1) < products.size && next_product = products[index + 1]
          return next_product
        end
      end

      nil
    end

    def search_products(search_terms)
      products.select { |p| p['name'].downcase.include?(search_terms.downcase) || p['description'].downcase.include?(search_terms.downcase) }
    end

    def country
      account['country']
    end

    def currency
      account['currency']
    end

    def locale
      currency['locale']
    end

    private

    def get(path)
      self.class.get(path).parsed_response
    end

    def lookup(permalink, array)
      array.find { |item| item['permalink'] == permalink }
    end

    def lookup_products(permalink, type)
      products.select { |p| p[type].any? { |c| c['permalink'] == permalink }}
    end
  end
end
