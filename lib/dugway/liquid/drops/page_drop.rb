module Dugway
  module Drops
    class PageDrop < BaseDrop
      def full_url
        @full_url
      end

      def full_path
        @context.registers[:full_path]
      end

      def meta_description    
        'Example meta description'
      end

      def meta_keywords
        'example, key, words'
      end

      def content
        'TODO'
      end
    end
  end
end
