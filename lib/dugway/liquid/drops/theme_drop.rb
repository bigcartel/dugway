module Dugway
  module Drops
    class ThemeDrop < BaseDrop
      def before_method(method_or_key)
        # We should try to get away from this api and use the newer one below
        if source.respond_to?('has_key?') && source.has_key?(method_or_key) && settings_images.find { |image| image['variable'] == method_or_key.to_s }
          return ImageDrop.new(source[method_or_key].stringify_keys)
        end

        super
      end

      # Newer API for theme images.
      # theme.images.logo
      def images
        Drops::ThemeImagesDrop.new(source)
      end

      def image_sets
        Drops::ThemeImageSetsDrop.new(source)
      end
    end
  end
end
