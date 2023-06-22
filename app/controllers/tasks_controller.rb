class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy] 
  skip_before_action :login_required
  
  def index
    @tasks = current_user.tasks.by_created_at
    @tasks = current_user.tasks.by_expired_at if params[:sort_expired].present?
    @tasks = current_user.tasks.by_priority if params[:sort_priority].present?
    @tasks = current_user.tasks.search_word(params[:search]).search_status(params[:status]) if params[:search].present? && params[:status].present?
    @tasks = current_user.tasks.search_word(params[:search]) if params[:search].present? && params[:status].nil?
    @tasks = current_user.tasks.search_status(params[:status]) if params[:status].present? && params[:search].nil?
    @tasks = @tasks.page(params[:page]).per(10)

    if params[:admin_user].present?
      if current_user.admin?
        redirect_to admin_users_path
      else
        redirect_to tasks_path, notice: '管理者のみアクセスできます'
      end
    end
  end

  def new
    @task = Task.new
  end

  def confirm
    @task = current_user.tasks.build(task_params)
    render :new if @task.invalid?
  end

  def create
    # binding.pry
    @task = current_user.tasks.build(task_params)
    @user = User.find(@task.user.id)
    if params[:back]
      render :new
    else
      if @task.save
        redirect_to user_path(@user.id)
        flash[:notice] = "タスクが登録出来ました!"
      else
        render :new
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:notice] = "タスクを編集しました!"
      redirect_to tasks_path
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:notice] = "タスクを削除しました!"
    redirect_to tasks_path
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :detail, :expired_at, :status, :priority)
  end
end
