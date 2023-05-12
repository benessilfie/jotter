# spec/controllers/concerns/authenticable_spec.rb
require "rails_helper"

RSpec.describe Authenticable do
  controller(ApplicationController) do
    include Authenticable

    def index
      user_signed_in?
      head :ok
    end
  end

  describe "#current_user" do
   let(:user) { create(:user) }

   context "when valid token is passed" do
     before do
       @request.headers["Authorization"] = "Bearer #{user.token}"
     end

     it "returns the current user" do
       expect(subject.current_user).to eq(user)
     end
   end

   context "when invalid token is passed" do
     before do
       @request.headers["Authorization"] = "invalid_token"
     end

     it "raises JWT::DecodeError error" do
       expect { subject.current_user }.to raise_error(JWT::DecodeError)
     end
   end
 end

  describe "#user_signed_in?" do
    let(:error_message) { "You need to sign in or sign up before continuing" }

    context "when current_user is present" do
      before do
        allow(subject).to receive(:current_user).and_return(create(:user))
      end

      it "does not render error message" do
        expect(subject).not_to receive(:render).with(json: { error: error_message }, status: :unauthorized)
        subject.user_signed_in?
      end
    end

    context "when current_user is nil" do
      before do
        allow(subject).to receive(:current_user).and_return(nil)
      end

      it "renders error message" do
        expect(subject).to receive(:render).with(json: { error: error_message }, status: :unauthorized)
        subject.user_signed_in?
      end
    end
  end
end
