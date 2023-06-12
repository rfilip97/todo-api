require "rails_helper"

RSpec.describe TodosController, type: :controller do
  describe "GET #index" do
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

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) { attributes_for(:todo) }

      it "returns status created" do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
      end

      it "creates a new todo" do
        expect {
          post :create, params: valid_params
        }.to change(Todo, :count).by(1)
      end

      it "returns the newly created todo" do
        todo = FactoryBot.build(:todo)

        post :create, params: { title: todo.title }
        json_response = JSON.parse(response.body)

        expect(json_response["title"]).to eq(todo.title)
        expect(json_response["position"]).to eq(1)
        expect(json_response["completed"]).to eq(false)
      end

      it "increments position" do
        post :create, params: { title: "First todo" }
        first_json_response = JSON.parse(response.body)

        post :create, params: { title: "Second todo" }
        second_json_response = JSON.parse(response.body)

        post :create, params: { title: "Third todo" }
        third_json_response = JSON.parse(response.body)

        expect(first_json_response["position"]).to eq(1)
        expect(second_json_response["position"]).to eq(2)
        expect(third_json_response["position"]).to eq(3)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          title: nil,
        }
      end

      it "does not create a new todo" do
        expect {
          post :create, params: invalid_params
        }.to_not change(Todo, :count)
      end

      it "returns status unprocessable_entity" do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
