class TodosController < ApplicationController
  include Filterable

  before_action :find_todo, only: [:update, :destroy]

  def index
    filter = params[:filter]
    all_todos = Todo.all

    filtered_todos = filter_by_status(all_todos, filter)
    active_todos = filter == VALID_FILTERS[:active] ? filtered_todos : filter_by_status(all_todos, VALID_FILTERS[:active])

    render json: { todos: filtered_todos, active_count: active_todos.length }
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
    params.permit(:title, :position, :completed, :filter)
  end

  def find_todo
    begin
      @todo = Todo.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Todo not found" }, status: :not_found
    end
  end

  def render_json_success(resource, status)
    render json: resource, status: status
  end

  def render_json_errors(errors, status)
    render json: { errors: errors }, status: status
  end
end
