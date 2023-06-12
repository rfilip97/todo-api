require 'rails_helper'

RSpec.describe "Todos", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/todos/index"
      expect(response).to have_http_status(:success)
    end
  end

end
