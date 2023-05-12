require "rails_helper"

RSpec.describe Auth::SessionsController, type: :request do
  let(:user) { create(:user) }

  describe "POST /auth/login" do
    context "when the email and password are correct" do
      it "returns a JWT token" do
        post "/auth/login", params: { email: user.email, password: user.password }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["token"]).not_to be_empty
      end
    end

    context "when the email is incorrect" do
      it "returns an error message" do
        post "/auth/login", params: { email: "example@hey.com", password: user.password }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq("Invalid email or password")
      end
    end

    context "when the password is incorrect" do
      it "returns an error message" do
        post "/auth/login", params: { email: user.email, password: "wrong_password" }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq("Invalid email or password")
      end
    end
  end

  describe "DELETE /auth/logout" do
    context "when the user is logged in" do
      it "logs out the user" do
        auth_token = user.token
        delete "/auth/logout", headers: { "Authorization" => auth_token }

        expect(response).to have_http_status(:no_content)
        expect(user.reload.auth_token).to be_nil
      end
    end

    context "when the user is not logged in" do
      it "returns an error message" do
        delete "/auth/logout"

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq("Missing token, please sign in or sign up")
      end
    end
  end
end
