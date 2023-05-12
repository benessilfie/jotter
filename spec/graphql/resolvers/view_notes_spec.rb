require "rails_helper"

RSpec.describe Resolvers::ViewNotes do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let!(:note) { create(:note, user: user) }

  context "when the user is authenticated" do
    it "returns the notes of the current logged in user" do
      query = <<~GQL
      query {
        viewNotes {
          id
          title
          content
          published
          user {
            email
            role
          }
        }
      }
    GQL

      result = JotterSchema.execute(query, context: { current_user: user })
      expect(result.dig("data", "viewNotes")).to be_present
      expect(result.dig("data", "viewNotes", 0, "user", "email")).to eq(user.email)
    end
  end

  context "when the user is not authenticated" do
    it "returns an error" do
      query = <<~GQL
      query {
        viewNotes {
          id
          title
          content
          published
          user {
            email
            role
          }
        }
      }
    GQL

      result = JotterSchema.execute(query, context: { current_user: nil })
      expect(result.dig("errors")).to be_present
    end
  end

  context "when attempting to view notes of another user" do
    it "returns an empty list" do
      query = <<~GQL
      query {
        viewNotes {
          id
          title
          content
          published
          user {
            email
            role
          }
        }
      }
    GQL

      result = JotterSchema.execute(query, context: { current_user: other_user })
      expect(result.dig("data", "viewNotes")).to be_blank
    end
  end

  context "when the user is an admin" do
    it "returns the notes of all users" do
      query = <<~GQL
      query {
        viewNotes {
          id
          title
          content
          published
          user {
            email
            role
          }
        }
      }
    GQL

      result = JotterSchema.execute(query, context: { current_user: create(:admin) })
      expect(result.dig("data", "viewNotes")).to be_present
      expect(result.dig("data", "viewNotes", 0, "user", "email")).to eq(user.email)
    end
  end
end
