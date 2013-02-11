require 'httparty'

module BigCartel
  module Builder
    class Store
      include HTTParty
  
      format :json
  
      def initialize(subdomain)
        self.class.base_uri "http://api.bigcartel.com/#{ subdomain }"
        @account = self.class.get('/store.js')
        @products = self.class.get('/products.js')
      end
  
      def account
        @account
      end
  
      def pages
        account.has_key?('pages') ? account['pages'] : []
      end
  
      def categories
        account.has_key?('categories') ? account['categories'] : []
      end
  
      def artists
        account.has_key?('artists') ? account['artists'] : []
      end
  
      def products
        @products
      end
    end
  end
end
