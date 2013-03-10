module Dugway
  class Cart
    attr_accessor :items

    def initialize
      reset
    end

    def reset
      self.items = []
    end

    def empty?
      items.empty?
    end

    def item_count
      items.map { |item| item.quantity }.inject(:+) || 0
    end

    def subtotal
      items.map { |item| item.price }.inject(:+) || 0.0
    end

    def total
      subtotal + shipping['amount'] + tax['amount'] - discount['amount']
    end

    def country
      nil
    end

    def shipping
      { 
        'enabled' => false,
        'amount' => 0.0,
        'strict' => false,
        'pending' => false
      }
    end

    def tax
      { 
        'enabled' => false,
        'amount' => 0.0
      }
    end

    def discount
      { 
        'enabled' => false,
        'pending' => false,
        'amount' => 0.0
      }
    end

    def update(params)
      add, adds, updates = params.delete(:add), params.delete(:adds), params.delete(:update)
      add_item(add) if add
      add_items(adds) if adds
      update_quantities(updates) if updates
    end

    def as_json(options=nil)
      {
        :item_count => item_count,
        :subtotal => subtotal,
        :price => subtotal, # deprecated but need this for backwards JS compatibility
        :total => total,
        :items => items,
        :country => country,
        :shipping => shipping,
        :discount => discount
      }
    end

    private

    def add_item(add)
      id = add[:id].to_i

      unless item = items.find { |i| i.option['id'] == id.to_i }
        product, option = Dugway.store.product_and_option(id)

        if product && option
          item = Item.new
          item.id = items.size + 1
          item.name = option['name'] == 'Default' ? product['name'] : "#{ product['name'] } - #{ option['name'] }"
          item.unit_price = option['price']
          item.product = product
          item.option = option
          item.quantity = 0

          items << item
        end
      end

      if item
        item.quantity += add[:quantity] ? add[:quantity].to_i : 1
      end

      item
    end

    def add_items(adds)
      adds.each { |add| add_item(add) }
    end

    def update_quantities(updates)
      updates.each_pair { |id, qty|
        if item = items.find { |i| i.id == id.to_i }
          item.quantity = qty.to_i
        end
      }

      items.reject! { |item| item.quantity == 0 }
    end
  end

  Item = Struct.new(:id, :name, :unit_price, :quantity, :product, :option) do
    def price
      unit_price * quantity
    end

    def as_json(options=nil)
      {
        :id => id,
        :name => name,
        :price => price,
        :unit_price => unit_price,
        :shipping => 0.0,
        :tax => 0.0,
        :total => price,
        :quantity => quantity,
        :product => product['permalink'],
        :option => option['id']
      }
    end
  end
end
