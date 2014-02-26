module Dugway
  module Drops
    class ThemeImageSetsDrop < BaseDrop
      def before_method(method_or_key)
        if source.respond_to?('has_key?') && source.has_key?(method_or_key) && settings_image_sets.find { |image| image['variable'] == method_or_key.to_s }
          source[method_or_key].map { |image| ImageDrop.new(image.stringify_keys) }
        else
          []
        end
      end

      private
      def settings_image_sets
        @settings_image_sets ||= settings.has_key?('image_sets') ? settings['image_sets'] : []
      end

      def settings
        @settings ||= @context.registers[:settings]
      end
    end
  end
end
