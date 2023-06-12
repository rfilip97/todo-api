require "rails_helper"

RSpec.describe TodosController, type: :controller do
  let!(:first_todo) { create(:todo) }
  let!(:second_todo) { create(:todo) }
  let!(:third_todo) { create(:todo) }

  it "returns all todos" do
    get :index
    expect(response).to have_http_status(:ok)

    json_response = JSON.parse(response.body)
    expect(json_response.length).to eq(3)
    expect(json_response.map { |todo| todo["id"] }).to match_array([first_todo.id, second_todo.id, third_todo.id])
  end
end
