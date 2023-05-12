require "rails_helper"

RSpec.describe "UsersController", type: :request do
  let(:user) { create(:user) }
  let(:token) { user.token }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  describe "GET /users/:id" do
    it "returns a user" do
      get user_path(user), headers: headers
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:attributes][:email]).to eq(user.email)
    end
  end

  describe "POST /users" do
      context "when the request is valid" do
        it "creates a user" do
          expect { post users_path, params: { user: user } }.to change(User, :count).by(1)
        end
      end

      context "when the request is invalid" do
        it "does not create a user" do
          expect { post users_path, params: { user: { email: nil } } }.to change(User, :count).by(0)
        end
      end
    end

  describe "PUT /users/:id" do
    context "when the user record exists" do
      it "updates the user" do
        patch user_path(user), params: { email: "ess@hey.com" }, headers: headers
        user.reload
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:attributes][:email]).to eq("ess@hey.com")
      end
    end

    context "when attempting to update another user" do
      it "returns not authorized" do
        patch user_path(7)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /users/:id" do
    context "when the user record exists" do
      it "deletes the user" do
        delete user_path(user), headers: headers

        expect(response).to have_http_status(:no_content)
      end
    end

    context "when attempting to delete another user" do
      it "returns not authorized" do
        delete user_path(0)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
