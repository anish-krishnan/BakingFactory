class UsersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :set_user, only: [:show, :edit, :update, :destroy, :activate, :deactivate]
  before_action :check_login
  authorize_resource

  def index
    @users = User.employees.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    @user.make_active
    if @user.save
      redirect_to @user, notice: "#{@user.username} was added to the system."
    else
      render action: 'new'
    end
  end


  def update
    if @user.update(user_params)
      redirect_to @user, notice: "#{@user.username} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def activate
    @user.make_active
    redirect_to @user, notice: "#{@user.username} was activated."
  end
  
  def deactivate
    @user.make_inactive
    redirect_to @user, notice: "#{@user.username} was deactivated."
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :role, :password, :password_confirmation, :active)
  end

end
