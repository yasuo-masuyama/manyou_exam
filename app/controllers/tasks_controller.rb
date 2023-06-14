class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy] 

  def index
    @tasks = Task.all
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
    params.require(:task).permit(:title, :detail)
  end
end
