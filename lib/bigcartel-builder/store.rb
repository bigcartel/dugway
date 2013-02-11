require 'httparty'

module BigCartel
  module Builder
    class Store
      include HTTParty
  
      format :json
  
      def initialize(subdomain)
        self.class.base_uri "http://api.bigcartel.com/#{ subdomain }"
      end
  
      def account
        @account ||= get('/store.js')
      end
      
      def theme_pages
        [
          { 'name' => 'Home', 'permalink' => 'home', 'url' => '/' },
          { 'name' => 'Products', 'permalink' => 'products', 'url' => '/products' },
          { 'name' => 'Product', 'permalink' => 'product', 'url' => '/product' },
          { 'name' => 'Cart', 'permalink' => 'cart', 'url' => '/cart' },
          { 'name' => 'Checkout', 'permalink' => 'checkout', 'url' => '/checkout' },
          { 'name' => 'Success', 'permalink' => 'success', 'url' => '/success' },
          { 'name' => 'Contact', 'permalink' => 'contact', 'url' => '/contact' },
          { 'name' => 'Maintenance', 'permalink' => 'maintenance', 'url' => '/maintenance' }    
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
        pages.find { |page| page['permalink'] == permalink }
      end
      
      def categories
        account.has_key?('categories') ? account['categories'] : []
      end
  
      def artists
        account.has_key?('artists') ? account['artists'] : []
      end
  
      def products
        @products ||= get('/products.js')
      end
      
      def currency
        @account['currency']
      end
      
      def country
        @account['country']
      end
      
      private
      
      def get(path)
        self.class.get(path).parsed_response
      end
    end
  end
end
