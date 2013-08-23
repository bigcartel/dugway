require 'will_paginate/array'

module Dugway
  module Drops
    class ProductsDrop < BaseDrop
      def all
        sort_and_paginate source
      end

      def current
        sort_and_paginate begin
          if artist.present?
            dropify store.artist_products(artist)
          elsif category.present?
            dropify store.category_products(category)
          elsif search_terms.present?
            dropify store.search_products(search_terms)
          else
            source
          end
        end
      end

      def on_sale
        sort_and_paginate source.select { |p| p['on_sale'] }
      end

      private

      def order
        if @context['internal']
          case @context['internal']['order']
          when 'newest', 'date'
            'date'
          # We don't pass these in the API, so fake it
          when 'sales', 'sells', 'views'
            'shuffle'
          else
            'position'
          end
        else
          'position'
        end
      end

      def sort_and_paginate(array)
        if order == 'shuffle'
          array.shuffle!
        elsif order == 'date'
          array.sort! { |a,b| b['id'] <=> a['id'] }
        else
          array.sort_by! { |p| p[order] }
        end

       array.paginate({
         :page => (page || 1),
         :per_page => per_page
       })
      end

      def artist
        @context.registers[:artist]['permalink'] rescue @context.registers[:params]['artist']
      end

      def category
        @context.registers[:category]['permalink'] rescue @context.registers[:params]['category']
      end

      def search_terms
        params[:search]
      end  

      def page
        if @context['internal'].present? && @context['internal'].has_key?('page') # has_key? here because 'page' will be nil for get blocks
          @context['internal']['page']
        else
          @context.registers[:params][:page] if @context.registers[:params]
        end
      end

      def per_page
        per_page = if @context['internal'] and @context['internal']['per_page'].present?
          @context['internal']['per_page']
        elsif theme.settings['products_per_page']
          theme.settings['products_per_page']
        else
          100
        end

        per_page.to_i
      end

      def dropify(products)
        products.map { |p| ProductDrop.new(p) }
      end
    end
  end
end
