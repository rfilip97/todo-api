class Todo < ApplicationRecord
  before_create :set_defaults

  private

  def set_defaults
    last_position = Todo.maximum(:position) || 0

    self.position = last_position + 1
    self.completed = false
  end
end
