module Filterable
  extend ActiveSupport::Concern

  VALID_FILTERS = {
    all: "all",
    active: "active",
    completed: "completed",
  }.freeze

  def filter_by_status(todos, filter)
    filter ||= VALID_FILTERS[:all]

    case filter
    when VALID_FILTERS[:active]
      todos.where(completed: false)
    when VALID_FILTERS[:completed]
      todos.where(completed: true)
    else
      todos
    end
  end
end
