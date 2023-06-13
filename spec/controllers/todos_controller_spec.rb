require "rails_helper"

RSpec.describe TodosController, type: :controller do
  describe "GET #index" do
    let!(:todos) { create_list(:todo, 3) }

    before { get :index }

    subject { JSON.parse(response.body) }

    it "returns HTTP status ok" do
      expect(response).to have_http_status(:ok)
    end

    it "returns all todos" do
      subject

      json_response = JSON.parse(response.body)
      expect(json_response["todos"].length).to eq(3)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) { attributes_for(:todo) }

      subject { post :create, params: valid_params }

      it "returns HTTP status Created" do
        subject
        expect(response).to have_http_status(:created)
      end

      it "creates a new todo" do
        expect { subject }.to change(Todo, :count).by(1)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { title: nil } }

      subject { post :create, params: invalid_params }

      it "returns HTTP status Unprocessable Entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create a new todo" do
        expect { subject }.not_to change(Todo, :count)
      end
    end
  end

  describe "PATCH #update" do
    let!(:todo) { create(:todo) }

    context "with valid parameters" do
      let(:new_attributes) { { title: "New title", position: 1, completed: true } }
      let(:params) { { id: todo.id }.merge(new_attributes) }

      subject { patch :update, params: params, as: :json }

      it "returns HTTP status OK" do
        subject
        expect(response).to have_http_status(:ok)
      end

      it "updates attributes" do
        subject
        todo.reload

        expect(todo.title).to eq(new_attributes[:title])
        expect(todo.completed).to eq(new_attributes[:completed])
        expect(todo.position).to eq(new_attributes[:position])
      end
    end

    context "with invalid title" do
      let(:invalid_params) { { id: todo.id, title: nil } }

      subject { patch :update, params: invalid_params, as: :json }

      it "returns HTTP status Unprocessable Entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not update the todo" do
        expect { subject }.not_to change { todo.reload.attributes }
      end
    end

    context "with invalid position" do
      let(:invalid_params) { { id: todo.id, position: "abcde" } }

      subject { patch :update, params: invalid_params, as: :json }

      it "returns HTTP status Unprocessable Entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not update the todo" do
        expect { subject }.not_to change { todo.reload.attributes }
      end
    end

    context "with invalid completed" do
      let(:invalid_params) { { id: todo.id, completed: "abcde" } }

      subject { patch :update, params: invalid_params, as: :json }

      it "returns HTTP status Unprocessable Entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not update the todo" do
        expect { subject }.not_to change { todo.reload.attributes }
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:todo) { create(:todo) }

    context "when the todo exists" do
      subject { delete :destroy, params: { id: todo.id } }

      it "destroys the todo" do
        expect { subject }.to change(Todo, :count).by(-1)
      end

      it "returns status no_content" do
        subject
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when the todo doesn't exist" do
      subject { delete :destroy, params: { id: 42 } }

      it "does not change the number of todos" do
        expect { subject }.not_to change(Todo, :count)
      end

      it "returns status not_found" do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it "returns an error message" do
        subject
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Todo not found")
      end
    end
  end
end
