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
  
      def pages
        account.has_key?('pages') ? account['pages'] : []
      end
      
      def page(permalink)
        get("/pages/#{ permalink }.js")
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
        self.class.get(path)
      end
    end
  end
end
