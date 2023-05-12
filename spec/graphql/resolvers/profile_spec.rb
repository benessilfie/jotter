require "rails_helper"

RSpec.describe Resolvers::Profile do
  let(:user) { create(:user) }

  context "when the user is authenticated" do
    it "returns the profile of the current logged in user" do
      query = <<~GQL
      query {
        profile {
          id
          email
          role
          createdAt
          updatedAt
        }
      }
    GQL

      result = JotterSchema.execute(query, context: { current_user: user })
      expect(result.dig("data", "profile", "id")).to eq(user.id.to_s)
      expect(result.dig("data", "profile", "email")).to eq(user.email)
      expect(result.dig("data", "profile", "role")).to eq(user.role)
    end
  end

  context "when the user is not authenticated" do
    it "returns an error" do
      query = <<~GQL
      query {
        profile {
          id
          email
          role
          createdAt
          updatedAt
        }
      }
    GQL

      result = JotterSchema.execute(query)
      expect(result.dig("data", "profile")).to be_nil
    end
  end
end
