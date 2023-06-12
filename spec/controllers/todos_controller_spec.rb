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

  describe "PATCH #update" do
    subject(:update_todo) { patch :update, params: params, as: :json }

    context "with valid parameters" do
      let(:params) { { id: todo.id, title: new_title, position: new_position, completed: new_completed } }
      let(:new_title) { "Clean the washing machine" }
      let(:new_position) { 999 }
      let(:new_completed) { true }
      let!(:todo) { create(:todo) }

      it "updates attributes" do
        update_todo
        todo.reload

        expect(todo.title).to eq(new_title)
        expect(todo.completed).to eq(new_completed)
        expect(todo.position).to eq(new_position)
      end

      it "returns 200" do
        update_todo

        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      let(:invalid_value) { "abcde" }
      let!(:todo) { create(:todo) }

      it "does not update title" do
        patch :update, params: { id: todo.id, title: nil }
        todo.reload

        expect(todo.title).not_to eq(nil)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not update position" do
        patch :update, params: { id: todo.id, position: invalid_value }
        todo.reload

        expect(todo.position).not_to eq(invalid_value)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not update completed" do
        patch :update, params: { id: todo.id, completed: invalid_value }
        todo.reload

        expect(todo.completed).not_to eq(invalid_value)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
