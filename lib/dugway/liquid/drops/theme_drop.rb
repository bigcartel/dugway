module Dugway
  module Drops
    class ThemeDrop < BaseDrop
      def before_method(method_or_key)
        if source.respond_to?('has_key?') && source.has_key?(method_or_key) && images.find { |image| image['variable'] == method_or_key.to_s }
          return ImageDrop.new(source[method_or_key].stringify_keys)
        end
        
        super
      end
      
      private
      
      def images
        @images ||= settings.has_key?('images') ? settings['images'] : []
      end
      
      def settings
        @settings ||= @context.registers[:settings]
      end
    end
  end
end
