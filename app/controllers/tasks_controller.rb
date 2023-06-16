class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy] 
  
  def index
    @tasks = Task.all
    @tasks = Task.all.by_created_at
    @tasks = Task.all.by_expired_at if params[:sort_expired].present?
    @tasks = Task.all.by_priority if params[:sort_priority].present?
    @tasks = Task.search_word(params[:search]).search_status(params[:status]) if params[:search].present? && params[:status].present?
    @tasks = Task.search_word(params[:search]) if params[:search].present? && params[:status].empty?
    @tasks = Task.search_status(params[:status]) if params[:status].present? && params[:search].empty?
    @tasks = @tasks.page(params[:page]).per(10)
  end

  def new
    @task = Task.new
  end

  def confirm
    @task = Task.new(task_params)
    render :new if @task.invalid?
  end

  def create
    if params[:back]
      render :new
    else
      @task = Task.new(task_params)
      if @task.save
        flash[:notice] = "タスクが登録出来ました!"
        redirect_to tasks_path
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
