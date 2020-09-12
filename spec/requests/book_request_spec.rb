require 'rails_helper'

RSpec.describe "Books", type: :request do

  describe "GET /viewbook_staff" do
    it "returns http success" do
      get "/book/viewbook_staff"
      expect(response).to have_http_status(:success)
    end
  end

end
