class SessionsController < ApplicationController
    include AppHelpers::Cart

    def new
    end

    def create
      user = User.authenticate(params[:username], params[:password])
      if user
        session[:user_id] = user.id

        create_cart

        if(user.role?(:admin))
          redirect_to dash_path, notice: "Logged in!"
        elsif(user.role?(:shipper))
          redirect_to shipinfo_path, notice: "Logged in!"
        elsif(user.role?(:baker))
          redirect_to bakeinfo_path, notice: "Logged in!"
        else
          redirect_to home_path, notice: "Logged in!"
        end
      else
        flash.now.alert = "Username and/or password is invalid"
        render "new"
      end
    end

    def destroy
      destroy_cart
      session[:user_id] = nil
      redirect_to home_path, notice: "Logged out!"
    end
  end