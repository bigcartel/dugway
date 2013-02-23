module Dugway
  module Filters
    module FontFilters
      def font_family(font_name)
        ThemeFont.find_family_by_name(font_name)
      end
    end
  end
end
