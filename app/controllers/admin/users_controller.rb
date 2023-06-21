class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[ edit update show destroy ]
  before_action :admin?

  def index
    @users = User.all.includes(:tasks)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: 'ユーザーを作成'
    else
      render :new
    end
  end

  def edit
  end

  def show
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'ユーザーを更新'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: 'ユーザーを削除'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def admin?
    unless current_user.admin?
      redirect_to tasks_path
      flash[:notice] = "管理者権限がありません"
    end
  end
end
