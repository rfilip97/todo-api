class Todo < ApplicationRecord
  before_validation :set_defaults, on: :create

  validates :title, presence: true
  validates :completed, inclusion: { in: [ true, false ] }

  private

  def set_defaults
    self.position = Todo.maximum(:position).to_i + 1
    self.completed = false
  end
end
