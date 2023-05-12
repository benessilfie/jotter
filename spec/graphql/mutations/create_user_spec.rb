require "rails_helper"

RSpec.describe Mutations::CreateUser do
  let(:user) { build(:user) }

  context "when the credentials are valid" do
    it "creates a user" do
      query = <<~GQL
        mutation {
          createUser(input: {
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

      result = JotterSchema.execute(query)
      expect(result.dig("data", "createUser", "user")).to be_present
    end
  end

  context "when the credentials are invalid" do
    it "returns an error" do
      query = <<~GQL
        mutation {
          createUser(input: {
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

      result = JotterSchema.execute(query)
      expect(result.dig("data", "createUser", "user")).to be_nil
      expect(result.dig("errors")).to be_present
    end
  end

  context "when the user already exists" do
    it "returns an error" do
      create(:user, email: user.email)

      query = <<~GQL
        mutation {
          createUser(input: {
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

      result = JotterSchema.execute(query)
      expect(result.dig("data", "createUser", "user")).to be_nil
      expect(result.dig("errors")).to be_present
    end
  end
end
