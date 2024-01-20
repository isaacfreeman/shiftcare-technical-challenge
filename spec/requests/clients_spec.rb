require 'rails_helper'

RSpec.describe "Clients requests", type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe "GET /query" do
    let(:params) { { q: "Isabella" } }
    let(:expected_response) do
      [
        {
          "id":14,
          "full_name":"Isabella Rodriguez",
          "email":"isabella.rodriguez@me.com"
        }
      ].to_json
    end

    it "responds with a JSON array of clients matching the query param" do
      get("/query", params: params, headers: headers)

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:success)
      expect(response.body).to eq expected_response
    end
  end
end
