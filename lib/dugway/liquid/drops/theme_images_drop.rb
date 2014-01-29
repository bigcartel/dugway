module Dugway
  module Drops
    class ThemeImagesDrop < BaseDrop
      def before_method(method_or_key)
        if source.respond_to?('has_key?') && source.has_key?(method_or_key) && settings_images.find { |image| image['variable'] == method_or_key.to_s }
          ImageDrop.new(source[method_or_key].stringify_keys)
        end
      end
    end
  end
end

