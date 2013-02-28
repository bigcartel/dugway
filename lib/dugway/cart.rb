module Dugway
  class Cart
    attr_accessor :items

    def initialize
      reset
    end

    def reset
      self.items = []
    end

    def update(params)
      add, adds, updates = params.delete(:add), params.delete(:adds), params.delete(:update)

      add_item(add) if add
      add_item(adds) if adds
      update_quantities(updates) if updates
    end

    def empty?
      items.empty?
    end

    private

    def add_item(add)
      id = add[:id].to_i

      unless item = items.find { |i| i['option']['id'] == id.to_i }
        product, option = Dugway.store.product_and_option(id)

        if product && option
          item = {
            'id' => items.size + 1,
            'name' => option['name'] == 'Default' ? product['name'] : "#{ product['name'] } - #{ option['name'] }",
            'unit_price' => option['price'],
            'product' => product,
            'option' => option,
            'quantity' => 0
          }

          items << item
        end
      end

      if item
        item['quantity'] += add[:quantity] ? add[:quantity].to_i : 1
      end

      item
    end

    def add_items(adds)
      if adds.kind_of?(Array)
        adds.each { |add| add_item(add) }
      elsif adds.kind_of?(Hash)
        adds.each_pair { |key, add| add_item(add.reverse_merge(:id => key)) }
      end
    end

    def update_quantities(updates)
      updates.each_pair { |id, qty|
        if item = items.find { |i| i['id'] == id.to_i }
          item['quantity'] = qty.to_i
        end
      }

      items.reject! { |item| item['quantity'] == 0 }
    end
  end
end
