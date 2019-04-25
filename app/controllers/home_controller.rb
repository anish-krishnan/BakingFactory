class HomeController < ApplicationController
  
  include AppHelpers::Cart

  def home
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

end