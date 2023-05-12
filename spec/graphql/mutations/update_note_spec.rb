require "rails_helper"

RSpec.describe Mutations::UpdateNote do
  let(:user) { create(:user) }
  let(:note) { create(:note, user: user) }

  context "when the user is authenticated" do
    it "updates a note" do
      query = <<~GQL
        mutation {
          updateNote(input: {
            id: #{note.id}
            title: "#{note.title}"
            content: "#{note.content}"
            published: #{note.published}
          }) {
            note {
              id
              title
              content
              published
            }
          }
        }
      GQL

      result = JotterSchema.execute(query, context: { current_user: user })
      expect(result.dig("data", "updateNote", "note")).to be_present
    end
  end

  context "when the user is not authenticated" do
    it "returns an error" do
      query = <<~GQL
        mutation {
          updateNote(input: {
            id: #{note.id}
            title: "#{note.title}"
            content: "#{note.content}"
            published: #{note.published}
          }) {
            note {
              id
              title
              content
              published
            }
          }
        }
      GQL

      result = JotterSchema.execute(query, context: { current_user: "" })
      expect(result.dig("errors", 0, "message")).not_to be_nil
    end
  end

  context "when the user is not the owner of the note" do
    it "returns an error" do
      query = <<~GQL
        mutation {
          updateNote(input: {
            id: #{note.id}
            title: "#{note.title}"
            content: "#{note.content}"
            published: #{note.published}
          }) {
            note {
              id
              title
              content
              published
            }
          }
        }
      GQL

      result = JotterSchema.execute(query, context: { current_user: create(:user2) })
      expect(result.dig("errors", 0, "message")).not_to be_nil
    end
  end

  context "when the note does not exist" do
    it "returns an error" do
      query = <<~GQL
        mutation {
          updateNote(input: {
            id: 0
            title: "#{note.title}"
            content: "#{note.content}"
            published: #{note.published}
          }) {
            note {
              id
              title
              content
              published
            }
          }
        }
      GQL

      result = JotterSchema.execute(query, context: { current_user: user })
      expect(result.dig("errors", 0, "message")).not_to be_nil
    end
  end

  context "when the user is an admin" do
    it "updates a note" do
      query = <<~GQL
        mutation {
          updateNote(input: {
            id: #{note.id}
            title: "#{note.title}"
            content: "#{note.content}"
            published: #{note.published}
          }) {
            note {
              id
              title
              content
              published
            }
          }
        }
      GQL

      result = JotterSchema.execute(query, context: { current_user: create(:admin) })
      expect(result.dig("data", "updateNote", "note")).to be_present
    end
  end
end
