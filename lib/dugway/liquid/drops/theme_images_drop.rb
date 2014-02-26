module Dugway
  module Drops
    class ThemeImagesDrop < BaseDrop
      def before_method(method_or_key)
        if source.respond_to?('has_key?') && source.has_key?(method_or_key) && settings_images.find { |image| image['variable'] == method_or_key.to_s }
          ImageDrop.new(source[method_or_key].stringify_keys)
        end
      end

      private
      def settings_images
        @settings_images ||= settings.has_key?('images') ? settings['images'] : []
      end

      def settings
        @settings ||= @context.registers[:settings]
      end
    end
  end
end

