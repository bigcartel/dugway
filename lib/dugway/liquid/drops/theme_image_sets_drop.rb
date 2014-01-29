module Dugway
  module Drops
    class ThemeImageSetsDrop < BaseDrop
      def before_method(method_or_key)
        if source.respond_to?('has_key?') && source.has_key?(method_or_key) && settings_image_sets.find { |image| image['variable'] == method_or_key.to_s }
          source[method_or_key].map { |image| ImageDrop.new(image.stringify_keys) }
        end
      end
    end
  end
end
