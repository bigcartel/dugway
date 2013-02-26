module Dugway
  module Drops
    class BaseDrop < Liquid::Drop
      attr_reader :source
      attr_reader :store
      attr_reader :request
      attr_reader :params

      def initialize(source=nil)
        @source = source
      end

      def context=(current_context)
        @store = current_context.registers[:store]
        @request = current_context.registers[:request]
        @params = current_context.registers[:params]
        super
      end

      def before_method(method_or_key)
        if source.respond_to?('has_key?') && source.has_key?(method_or_key)
          return source[method_or_key]
        elsif source.is_a?(Array) && source.first.has_key?('permalink')
          for item in source
            return item if item['permalink'] == method_or_key.to_s
          end
        end

        nil
      end
      
      def method_missing(method, *args, &block)
        before_method(method.to_s)
      end
      
      def error(msg)
        @context['errors'] << msg
        Dugway.logger.error msg
      end
    end
  end
end
