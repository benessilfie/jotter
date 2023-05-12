require "rails_helper"

RSpec.describe Mutations::AuthenticateUser do
  let(:user) { create(:user) }

  it "authenticates a user and returns a token" do
    query = <<~GQL
      mutation {
        authenticateUser(input: {
          email: "#{user.email}",
          password: "#{user.password}"
        }) {
          token
        }
      }
    GQL

    result = JotterSchema.execute(query)
    expect(result.dig("data", "authenticateUser", "token")).to be_present
  end

  it "returns an error when authentication fails" do
    query = <<~GQL
      mutation {
        authenticateUser(input: {
          email: "#{user.email}",
          password: "wrong_password"
        }) {
          token
        }
      }
    GQL

    result = JotterSchema.execute(query)
    expect(result.dig("errors", 0, "message")).not_to be_nil
  end
end
