class Todo < ApplicationRecord
  before_create :set_defaults

  validates :title, presence: true

  private

  def set_defaults
    last_position = Todo.maximum(:position) || 0

    self.position = last_position + 1
    self.completed = false
  end
end
