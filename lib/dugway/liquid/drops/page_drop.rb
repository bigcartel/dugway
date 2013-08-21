module Dugway
  module Drops
    class PageDrop < BaseDrop
      def meta_description
        'Example meta description'
      end

      def meta_keywords
        'example, key, words'
      end

      def full_url
        @request.url
      end

      def full_path
        @request.path
      end
    end
  end
end
