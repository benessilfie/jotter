require "rails_helper"

RSpec.describe Mutations::UpdateUser do
  let(:user) { create(:user) }

  context "when the credentials are valid" do
    it "updates a user" do
      query = <<~GQL
        mutation {
          updateUser(input: {
            role: member
          }) {
            user {
              id
              email
              role
            }
          }
        }
      GQL

      result = JotterSchema.execute(query, context: { current_user: user })
      expect(result.dig("data", "updateUser", "user")).to be_present
    end
  end

  context "when the credentials are invalid" do
    it "returns an error" do
      query = <<~GQL
        mutation {
          updateUser(input: {
            id: "#{user.id}"
            email: "someemail"
            password: "fdsafd"
            role: member
          }) {
            user {
              id
              email
              role
            }
          }
        }
      GQL

      result = JotterSchema.execute(query, context: { current_user: user })
      expect(result.dig("data", "updateUser", "user")).to be_nil
      expect(result.dig("errors")).to be_present
    end
  end

  context "when the user does not exist" do
    it "returns an error" do
      query = <<~GQL
        mutation {
          updateUser(input: {
            id: "someid"
            email: "#{user.email}"
            password: "#{user.password}"
            role: member
          }) {
            user {
              id
              email
              role
            }
          }
        }
      GQL

      result = JotterSchema.execute(query, context: { current_user: user })
      expect(result.dig("data", "updateUser", "user")).to be_nil
      expect(result.dig("errors")).to be_present
    end
  end
end
