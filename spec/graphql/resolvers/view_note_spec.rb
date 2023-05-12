require "rails_helper"

RSpec.describe Resolvers::ViewNote do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:note) { create(:note, user: user) }
  let(:other_note) { create(:note2, user: other_user) }

  context "when the user is authenticated" do
    it "returns the user's note when provided a valid id" do
      query = <<~GQL
      query {
        viewNote(id: "#{note.id}") {
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
      expect(result.dig("data", "viewNote")).to be_present
      expect(result.dig("data", "viewNote", "user", "email")).to eq(user.email)
    end

    it "returns an error when provided an invalid id" do
      query = <<~GQL
      query {
        viewNote(id: "invalid") {
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
      expect(result.dig("data", "viewNote")).to be_nil
      expect(result.dig("errors", 0, "message")).to be_present
    end
  end

  context "when the user is not authenticated" do
    it "returns an error" do
      query = <<~GQL
      query {
        viewNote(id: "#{note.id}") {
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

      result = JotterSchema.execute(query, context: {})
      expect(result.dig("data", "viewNote")).to be_nil
      expect(result.dig("errors", 0, "message")).to be_present
    end
  end

  context "when attempting to view a note of another user" do
    it "returns an error" do
      query = <<~GQL
      query ($id: ID!) {
        viewNote(id: $id) {
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

      result = JotterSchema.execute(query, variables: { id: note.id }, context: { current_user: other_user })
      expect(result.dig("data", "viewNote")).to be_nil
      expect(result.dig("errors", 0, "message")).to be_present
    end
  end

  context "when the user is an admin" do
    it "views any user's note when provided a valid id" do
      query = <<~GQL
      query {
        viewNote(id: "#{other_note.id}") {
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
      expect(result.dig("data", "viewNote")).to be_present
      expect(result.dig("data", "viewNote", "user")).to be_present
    end
  end
end
