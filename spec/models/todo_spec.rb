require "rails_helper"

RSpec.describe Todo, type: :model do
  describe "#validations" do
    it { should validate_presence_of(:title) }

    context "with valid params" do
      todo = FactoryBot.build(:todo)

      it { expect(todo).to be_valid }
    end

    context "with invalid title" do
      todo = FactoryBot.build(:todo, title: nil)

      it { expect(todo).not_to be_valid }
    end
  end
end