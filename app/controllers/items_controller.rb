  class ItemsController < ApplicationController
  before_action :check_login, except: [:index, :show]
  before_action :set_item, only: [:show, :edit, :update, :destroy, :addToCart, :deleteFromCart, :activate, :deactivate]
  authorize_resource

  include AppHelpers::Cart
  
  def index
    # get info on active items for the big three...
    @breads = Item.active.for_category('bread').alphabetical.paginate(:page => params[:page]).per_page(10)
    @muffins = Item.active.for_category('muffins').alphabetical.paginate(:page => params[:page]).per_page(10)
    @pastries = Item.active.for_category('pastries').alphabetical.paginate(:page => params[:page]).per_page(10)
    # get a list of any inactive items for sidebar
    @inactive_items = Item.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    if logged_in? && current_user.role?(:admin)
      # admin gets a price history in the sidebar
      @previous_prices = @item.item_prices.chronological.reverse.to_a
    end
    # everyone sees similar items in the sidebar
    @similar_items = Item.for_category(@item.category).alphabetical.to_a
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def activate
    @item.make_active
    redirect_to items_path, notice: "#{@item.name} was activated."
  end
  
  def deactivate
    @item.make_inactive
    redirect_to items_path, notice: "#{@item.name} was deactivated."
  end

  def addToCart
    if(@item.current_price.nil?)
      redirect_to @item, notice: "OOPS!   #{@item.name} does not have a price. Cannot add to cart"
    else
      add_item_to_cart(@item.id.to_s)
      redirect_to @item, notice: "#{@item.name} was added to the cart."
    end
  end

  def deleteFromCart
    remove_item_from_cart(@item.id.to_s)
    redirect_to cart_path, notice: "#{@item.name} was removed from the cart."
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to @item, notice: "#{@item.name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: "#{@item.name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @item.destroy
    redirect_to items_url, notice: "#{@item.name} was removed from the system."
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :picture, :category, :units_per_item, :weight, :active)
  end

end