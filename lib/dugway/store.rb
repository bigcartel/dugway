require 'httparty'

module Dugway
  class Store
    include HTTParty

    format :json
    default_timeout 5

    def initialize(subdomain)
      self.class.base_uri "http://api.bigcartel.com/#{ subdomain }"
    end

    def account
      @account ||= get('/store.js')
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
        custom_pages = custom_pages.map { |page| get("/page/#{ page['permalink'] }.js") }
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
      @products ||= get('/products.js')
    end
    
    def product(permalink)
      lookup(permalink, products)
    end

    def product_and_option(option_id)
      products.each { |product|
        product['options'].each { |option|
          if option['id'] == option_id
            return product, option
          end
        }
      }

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
      case currency['code']
      when 'AUD' then 'en-AU'
      when 'BRL' then 'pt-BR'
      when 'CAD' then 'en-US'
      when 'CZK' then 'cs'
      when 'DKK' then 'da'
      when 'EUR' then 'eu'
      when 'HKD' then 'en-US'
      when 'HUF' then 'hu'
      when 'ILS' then 'il'
      when 'JPY' then 'ja'
      when 'MYR' then 'ms-MY'
      when 'MXN' then 'es-MX'
      when 'TWD' then 'zh-TW'
      when 'NZD' then 'en-US'
      when 'NOK' then 'nb'
      when 'PHP' then 'en-PH'
      when 'PLN' then 'pl'
      when 'GBP' then 'en-GB'
      when 'SGD' then 'en-US'
      when 'SEK' then 'sv-SE'
      when 'CHF' then 'gsw-CH'
      when 'THB' then 'th'
      when 'TRY' then 'tr'
      else 'en-US'
      end
    end
    
    private
    
    def get(path)
      self.class.get(path).parsed_response
    end
  
    def lookup(permalink, array)
      array.find { |item| item['permalink'] == permalink }.try(:dup)
    end
    
    def lookup_products(permalink, type)
      products.select { |p| p[type].any? { |c| c['permalink'] == permalink }}
    end
  end
end
