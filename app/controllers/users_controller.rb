class UsersController < ApplicationController
  skip_before_action :login_required, only: %i[ new create ]
  before_action :unable_new, only: %i[ new ]

  def new
    @user = User.new
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    if @user == current_user
      @user
    else
      redirect_to tasks_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def unable_new
    redirect_to tasks_path if current_user.present?
  end
end