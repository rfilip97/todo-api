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

    context "default values" do
      let!(:todo) { FactoryBot.create(:todo) }

      it { expect(todo).to be_valid }
      it { expect(todo.completed).to be false }
      it { expect(todo.position).to be 1 }
    end

    context "increment default position" do
      let!(:todo) { FactoryBot.create(:todo) }
      let!(:another_todo) { FactoryBot.create(:todo) }

      it { expect(todo).to be_valid }
      it { expect(another_todo).to be_valid }
      it { expect(another_todo.position).to be 2 }
    end
  end
end