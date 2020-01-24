class Cart
    def initialize(item_hash)
        item_hash ||= {}
        raise ArgumentError if item_hash.class != Hash
        @items = item_hash
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

    def to_h
        # test passed with this code
        # hash_item = {}
        #     hash_item = @items
        # hash_item
        @items
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
    end 
end 