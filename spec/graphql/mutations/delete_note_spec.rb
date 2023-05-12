require "rails_helper"

RSpec.describe Mutations::DeleteNote do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:note) { create(:note, user: user) }
  let(:other_note) { create(:note, user: other_user) }

  context "when the user is authenticated" do
    it "deletes their own note" do
      query = <<~GQL
        mutation {
          deleteNote(input: { id: #{note.id} }) {
            message
          }
        }
      GQL

      result = JotterSchema.execute(query, context: { current_user: user })
      expect(result.dig("data", "deleteNote", "message")).to be_present
    end

    it "does not delete another user's note" do
      query = <<~GQL
        mutation {
          deleteNote(input: { id: #{other_note.id} }) {
            message
          }
        }
      GQL

      result = JotterSchema.execute(query, context: { current_user: user })
      expect(result.dig("data", "deleteNote", "message")).to be_nil
    end
  end

  context "when the user is not authenticated" do
    it "returns an error" do
      query = <<~GQL
        mutation {
          deleteNote(input: { id: #{note.id} }) {
            message
          }
        }
      GQL

      result = JotterSchema.execute(query, context: { current_user: "" })
      expect(result.dig("errors", 0, "message")).not_to be_nil
    end
  end

  context "when the note does not exist" do
    it "returns an error" do
      query = <<~GQL
        mutation {
          deleteNote(input: { id: 0 }) {
            message
          }
        }
      GQL

      result = JotterSchema.execute(query, context: { current_user: user })
      expect(result.dig("errors", 0, "message")).not_to be_nil
    end
  end

  context "when the user is an admin" do
    it "delete any user's note" do
      query = <<~GQL
        mutation {
          deleteNote(input: { id: #{other_note.id} }) {
            message
          }
        }
      GQL

      result = JotterSchema.execute(query, context: { current_user: create(:admin) })
      expect(result.dig("data", "deleteNote", "message")).to be_present
    end
  end
end
