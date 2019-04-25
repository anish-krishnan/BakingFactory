class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :destroy]
  before_action :check_login
  authorize_resource

  include AppHelpers::Cart
  
  def index
    @all_orders = Order.chronological.paginate(:page => params[:page]).per_page(10)
    if logged_in? && current_user.role?(:customer)
      @customer_orders = Order.where("customer_id = ?", current_user.customer.id).paginate(:page => params[:page]).per_page(10)
    else
      @customer_orders = nil
    end
  end

  def show
    @unshipped_items = @order.order_items.unshipped
    @shipped_items = @order.order_items.shipped
    @previous_orders = @order.customer.orders.chronological.to_a
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.date = Date.current
    if(current_user.role? :customer)
      @order.customer_id = current_user.customer.id
      @order.credit_card_number = @order.credit_card_number.to_s
      @order.expiration_year = @order.expiration_year.to_i
      @order.expiration_month = @order.expiration_month.to_i
    end

    if @order.save!
      save_each_item_in_cart(@order)

      @order.grand_total = @order.shipping_costs + calculate_cart_items_cost
      @order.pay
      clear_cart
      redirect_to @order, notice: "Thank you for ordering from the Baking Factory."
    else
      render action: 'new'
    end
  end

  def checkout
    @order = Order.new(order_checkout_params)
    @order.date = Date.current
    save_each_item_in_cart(@order)

    @order = shipping_costs + calculate_cart_items_cost

    if @order.save
      @order.pay
      redirect_to @order, notice: "Thank you for ordering from the Baking Factory."
    else
      render action: 'new'
    end
  end
  

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    if(current_user.role? :customer)
      params.require(:order).permit(:address_id, :credit_card_number, :expiration_year, :expiration_month)
    else
      params.require(:order).permit(:address_id, :customer_id, :grand_total)
    end
  end

end