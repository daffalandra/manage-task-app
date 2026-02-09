class TasksController < ApplicationController
  before_action :set_task, only: [ :show, :edit, :update, :destroy ]

  # GET /tasks
  def index
    @tasks = Task.all.order(created_at: :desc)
  end

  # GET /tasks/:id
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/:id/edit
  def edit
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_path, notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/:id
  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/:id
  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "Task was successfully deleted."
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority)
  end
end
