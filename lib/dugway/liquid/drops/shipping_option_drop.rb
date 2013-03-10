module Dugway
  module Drops
    class ShippingOptionDrop < BaseDrop
      def country
        @country ||= CountryDrop.new(source['country'])
      end

      # internal

      def strict
        @strict ||= product.shipping.size > 1 || product.shipping.first.country.name.present?
      end
    end
  end
end
