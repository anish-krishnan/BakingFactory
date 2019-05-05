class HomeController < ApplicationController
  
  include AppHelpers::Cart

  def home
    if logged_in? && current_user.role?(:customer)
      items = {}
      OrderItem.all.each do |oi|
        if(items[oi.item_id].nil?)
          items[oi.item_id] = (oi.quantity)
        else
          items[oi.item_id] += oi.quantity
        end
      end
      items = items.sort{|i1,i2| i1[1] <=> i2[1]}.reverse.map{|i,q| Item.find(i)}

      customer = current_user.customer
      if(customer.orders.empty?)
        @prevItems = nil
        @suggestedItem = items[0]
      else
        @prevItems = customer.orders.last.order_items.map{|oi| oi.item}
        @suggestedItem = (items - @prevItems)[0]
      end

    end
  end

  def about
  end

  def privacy
  end

  def contact
  end

  def cart
    @cart_items = get_list_of_items_in_cart
    @subtotal = calculate_cart_items_cost
  end

  def cart_reset
    clear_cart
    redirect_to home_path, notice: "Cart has been cleared!"
  end

  def shipinfo
    @orders = Order.not_shipped
  end

  def bakeinfo
    all_order_items = OrderItem.unshipped

    items = {}
    bread = {}
    muffins = {}
    pastries = {}

    all_order_items.each do |oi|
      if(items[oi.item_id].nil?)
        items[oi.item_id] = (oi.quantity)
      else
        items[oi.item_id] += oi.quantity
      end
    end

    items.each do |id, q|
      case Item.find(id).category
      when "bread"
        bread[id] = q
      when "muffins"
        muffins[id] = q
      when "pastries"
        pastries[id] = q
      end
    end

    @items = items
    @bread = bread
    @muffins = muffins
    @pastries = pastries
  end

  def search
    redirect_back(fallback_location: home_path) if params[:query].blank?
    @query = params[:query]
    @items = Item.search(@query)
    
    if logged_in? && current_user.role?(:admin)
      @customers = Customer.search(@query)
      @total_hits = @items.size + @customers.size
    else
      @customers = nil
      @total_hits = @items.size
    end
  end


  def dash
    items = {}
    OrderItem.all.each do |oi|
      if(items[oi.item_id].nil?)
        items[oi.item_id] = (oi.quantity)
      else
        items[oi.item_id] += oi.quantity
      end
    end

    @topItems = items.sort{|i1,i2| i1[1] <=> i2[1]}.reverse[0..2]
    @topCustomers = Customer.all.sort{|c1,c2| c1.orders.size <=> c2.orders.size }.reverse[0..4]
    @totalEarnings = Order.paid.inject(0) {|sum, order| sum += order.grand_total}
    @data = [43934, 52503, 57177, 69658, 97031, 119931, 137133, 154175]

    minOrderDate = Order.all.map(&:date).select{|i| !i.nil?}.min
    curDate = minOrderDate
    @data = []

    while(curDate <= Date.today)
      monthTotal = Order.in_range(curDate, curDate + 1.month).paid.inject(0) {|sum, order| sum += order.grand_total}
      @data << [curDate.to_time.to_i, monthTotal]
      curDate += 1.month
    end
    @data = @data.map{|x,y| [x*1000, y]}

  end

end