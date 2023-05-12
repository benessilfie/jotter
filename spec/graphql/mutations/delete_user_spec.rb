require "rails_helper"

RSpec.describe Mutations::DeleteUser do
  let(:user) { create(:user) }

  context "when the user exists" do
    it "deletes a user" do
      query = <<~GQL
        mutation {
          deleteUser(input: {
             password: "#{user.password}"
          }) {
            message
          }
        }
      GQL

      result = JotterSchema.execute(query, context: { current_user: user })
      expect(result.dig("data", "deleteUser", "message")).to be_present
    end
  end

  context "when the user does not exist" do
    it "returns an error" do
      query = <<~GQL
        mutation {
          deleteUser(input: {
              password: "somepassword"
          }) {
            message
          }
        }
      GQL

      result = JotterSchema.execute(query, context: { current_user: user })
      expect(result.dig("data", "deleteUser", "user")).to be_nil
      expect(result.dig("errors")).to be_present
    end
  end
end
