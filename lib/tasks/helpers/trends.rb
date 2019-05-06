module Populator
  module Trends
    def create_trends_with(customers)

      puts "Creating a set of orders for cream puffs this past week..."
      count = 0

      customers.each do |customer|
        unless rand(2)==0   
          ordering_dates = (6.days.ago.to_date..Date.current).to_a.shuffle
          count += 1
          puts " -- created cream puffs orders for #{count} customers" if count%10==0
          c_address_ids = customer.addresses.map(&:id)

          [1,1,1,2,3].sample.times do |i|
            order = Order.new
            order.credit_card_number = '4123456789012'
            order.expiration_year = Date.current.year
            order.expiration_month = Date.current.month
            order.customer_id = customer.id
            order.address_id = c_address_ids.sample
            order.save
            new_date = ordering_dates.pop
            order.update_attribute(:date, new_date)
            order.reload
            total = 0
            # create an order item for cream puffs
              this_item = Item.where(name: "Cream Puffs").first
              oi = OrderItem.new
              oi.item_id = this_item.id
              oi.order_id = order.id
              oi.quantity = [2,3,4].sample
              oi.save!
              total += oi.subtotal(order.date)
            # record total and payment
            total += order.shipping_costs
            order.update_attribute(:grand_total, total)
            order.pay
            # ship the items
            unless order.date == Date.current
              order.order_items.each{|oi2| oi2.shipped_on = order.date + 1; oi2.save! }
            end
          end
        end
      end

      puts "Creating a set of orders for Challah Bread this past month..."
      count = 0
      customers.each do |customer|
        unless rand(3)==0 
          ordering_dates = (30.days.ago.to_date..8.days.ago.to_date).to_a.shuffle
          count += 1
          puts " -- created challah bread orders for #{count} customers" if count%10==0
          c_address_ids = customer.addresses.map(&:id)
          [1,2,2,3,3,3,4,4,4,4,5,5,6,7,8,9].sample.times do |i|
            order = Order.new
            order.credit_card_number = '4123456789012'
            order.expiration_year = Date.current.year
            order.expiration_month = Date.current.month
            order.customer_id = customer.id
            order.address_id = c_address_ids.sample
            order.save
            new_date = ordering_dates.pop
            order.update_attribute(:date, new_date)
            order.reload
            total = 0
            # create an order item for Challah
              this_item = Item.where(name: "Challah Bread").first
              oi = OrderItem.new
              oi.item_id = this_item.id
              oi.order_id = order.id
              oi.quantity = [2,3,4,5].sample
              oi.save!
              total += oi.subtotal(order.date)
            # record total and payment
            total += order.shipping_costs
            order.update_attribute(:grand_total, total)
            order.pay
            # ship the items
            unless order.date == Date.current
              order.order_items.each{|oi2| oi2.shipped_on = order.date + 1; oi2.save! }
            end
          end
        end
      end

      puts "Creating a special set of orders for Bruce Wayne this month..."
      count = 0
      customer = Customer.first
      billing = FactoryBot.create(:address, customer: customer, 
        recipient: "Bruce Wayne",
        street_1: "One Gotham Mansion",
        city: "Gotham City",
        state: "NY",
        zip: "10001",
        is_billing: true)
      all_items = Item.all
      c_address_ids = customer.addresses.map(&:id)

      (6.days.ago.to_date..Date.current).to_a.each do |order_date|
        customer_selections = all_items.shuffle
        order = Order.new
        order.credit_card_number = '4123456789012'
        order.expiration_year = Date.current.year
        order.expiration_month = Date.current.month
        order.customer_id = customer.id
        order.address_id = c_address_ids.sample
        order.save
        order.update_attribute(:date, order_date)
        order.reload
        total = 0
        [2,2,3,3,4,5].sample.times do |j|
          this_item = customer_selections.pop
          oi = OrderItem.new
          oi.item_id = this_item.id
          oi.order_id = order.id
          oi.quantity = [2,3,4].sample
          oi.save!
          total += oi.subtotal(order.date)
        end
        # record total and payment
        total += order.shipping_costs
        order.update_attribute(:grand_total, total)
        order.pay
        # ship the items
        unless order.date == Date.current
          order.order_items.each{|oi2| oi2.shipped_on = order.date + 1; oi2.save! }
        end
      end
    end

    def create_unordered_item
      blackberry = FactoryBot.create(:item, 
        name: "Blackberry Turnovers", 
        description: "A delicious, flaky turnover pastry made with fresh blackberries.  This tasty pastry makes great holiday gifts for friends and family who don't have dentures.", 
        units_per_item: 1, 
        category: "pastries", 
        weight: 1.2)
      # prices
      bb1 = FactoryBot.create(:item_price, item: blackberry, price: 4.95, start_date: 12.months.ago.to_date)
      bb1.update_attribute(:start_date, 12.months.ago.to_date)
      bb2 = FactoryBot.create(:item_price, item: blackberry, price: 5.95, start_date: 6.months.ago.to_date)
      bb2.update_attribute(:start_date, 6.months.ago.to_date)
      bb1.update_attribute(:end_date, 6.months.ago.to_date - 1)
      bb3 = FactoryBot.create(:item_price, item: blackberry, price: 6.95, start_date: 2.weeks.ago.to_date)
      bb3.update_attribute(:start_date, 2.weeks.ago.to_date)
      bb2.update_attribute(:end_date, 2.weeks.ago.to_date - 1)
    end

  end
end
