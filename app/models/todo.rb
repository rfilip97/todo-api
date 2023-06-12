class Todo < ApplicationRecord
  before_create :set_initial_position

  private

  def set_initial_position
    last_position = Todo.maximum(:position) || 0
    self.position = last_position + 1
  end
end
