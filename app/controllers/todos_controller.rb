class TodosController < ApplicationController
  before_action :find_todo, only: [:update, :destroy]

  def index
    @todos = Todo.all
    render json: @todos
  end

  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      render_json_success(@todo, :created)
    else
      render_json_errors(@todo.errors, :unprocessable_entity)
    end
  end

  def update
    if @todo.update(todo_params)
      render_json_success(@todo, :ok)
    else
      render_json_errors(@todo.errors, :unprocessable_entity)
    end
  end

  def destroy
    if @todo.destroy
      head :no_content
    else
      render_json_errors(@todo.errors, :unprocessable_entity)
    end
  end

  private

  def todo_params
    params.permit(:title, :position, :completed)
  end

  def find_todo
    @todo = Todo.find(params[:id])
  end

  def render_json_success(resource, status)
    render json: resource, status: status
  end

  def render_json_errors(errors, status)
    render json: { errors: errors }, status: status
  end
end
