class TodosController < ApplicationController
  before_action :find_todo, only: [:update]

  def index
    @todos = Todo.all
    render json: @todos
  end

  def create
    @todo = Todo.new(todo_params)
    if @todo.save
      render json: @todo, status: :created
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def update
    validation_errors = validate_params(todo_params)

    if validation_errors.empty?
      if @todo.update(todo_params)
        render json: @todo, status: :ok
      else
        render json: @todo.errors, status: :unprocessable_entity
      end
    else
      render json: { errors: validation_errors }, status: :unprocessable_entity
    end
  end

  private

  def todo_params
    params.permit(:title, :position, :completed)
  end

  def find_todo
    @todo = Todo.find(params[:id])
  end

  def boolean?(value)
    value == true || value == false
  end

  def validate_params(params)
    errors = {}

    if params.key?(:completed) && !boolean?(params[:completed])
      errors[:completed] = "must be a boolean value"
    end

    errors
  end
end
