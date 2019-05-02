class OrderItemsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :set_order_item, only: [:show, :edit, :update, :destroy, :toggleshipped]
  # before_action :check_login, only: [:show, :edit, :update, :destroy, :index]
  
  authorize_resource

  include AppHelpers::Cart

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def toggleshipped
    puts "YESSSS"
    @order_item.toggle_shipping
    redirect_to shipinfo_path, notice: "#{@order_item.item.name} was marked as shipped."
  end


  private
  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

end