class Cart
    def initialize(item_hash, discount=0.0)
        item_hash ||= {}

        raise ArgumentError if item_hash.class != Hash
        raise ArgumentError if discount.class != Float

        @items = item_hash
        @discount = discount
    end 

    def line_items
        result = []
        @items.each do |id, quantity|
            result.push(LineItem.new(id, quantity))
        end
        result
    end

    def add_by_id(id)
        @items[id] ||= 0
        @items[id] += 1
        LineItem.new(id, @items[id])
    end

    def remove_by_id(id)
        if(@items.keys.include?(id))
            result = LineItem.new(id, @items[id])
            @items.delete(id)
            result
        else
           nil
        end
    end 

    def to_h
        # test passed with this code
        # hash_item = {}
        #     hash_item = @items
        # hash_item
        @items
    end 

    def subtotal 
        # result = 0
        # line_items.each do |item|
        #     result += item.product.price_in_cents * item.quantity
        # end
        # result
        line_items.inject(0) { | subtotal, item | subtotal += item.total  } 
    end 

    def discount
        (subtotal * @discount).round
    end

    def total
        subtotal - discount
    end

    def totals(line_name)
        raise ArgumentError unless [:subtotal, :discount, :total].include?(line_name)

        Money.new(send(line_name))
    end

    class LineItem
        attr_reader :quantity

        def initialize(id, quantity)
            @id = id
            @quantity = quantity
        end

        def product
            Product.find(@id)
        end

        def total
            product.price_in_cents * quantity
        end 

        def unit_price
            Money.new(product.price_in_cents)
        end 

        def price
            Money.new(total)
        end
    end 

    class Money 
        def initialize(cents) 
            @cents = cents
        end 
    
        def to_s
            # result = "$"
            # result += (@cents/100).to_s
            # result += "."
            # remainder = (@cents%100).to_s
            # if(@cents%100 < 10)
            #     result += "0" + remainder
            # elsif(remainder.length == 1 )
            #     result += remainder + "0"
            # else 
            #     result += remainder
            # end
            # result
            "$%0.2f" % [@cents/100.0]
        end
    end 
end 