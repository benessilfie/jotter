require "rails_helper"

RSpec.describe Mutations::CreateNote do
  let(:user) { create(:user) }
  let(:note) { create(:note, user: user) }

  context "when the user is authenticated" do
    it "creates a note" do
      query = <<~GQL
        mutation {
          createNote(input: {
            title: "#{note.title}",
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
      expect(result.dig("data", "createNote", "note")).to be_present
    end
  end

  context "when the user is not authenticated" do
    it "returns an error" do
      query = <<~GQL
        mutation {
          createNote(input: {
            title: "#{note.title}",
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
end
