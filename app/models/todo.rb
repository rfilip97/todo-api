class Todo < ApplicationRecord
  before_validation :set_defaults, on: :create

  validates :title, presence: { message: "Title can't be blank" }
  validates :position, numericality: { only_integer: true }
  validate :completed_value, on: :update

  private

  def set_defaults
    self.position = Todo.maximum(:position).to_i + 1
    self.completed = false
  end

  def completed_value
    raw_value = self.completed_before_type_cast

    unless boolean?(raw_value)
      errors.add(:completed, "must be a boolean value")
    end
  end

  def boolean?(value)
    value == true || value == false
  end
end
