module Mutations
  class CreateNote < BaseMutation
    argument :title, String, required: true
    argument :content, String, required: true
    argument :published, Boolean, required: false

    field :note, Types::NoteType, null: true

    def execute(title:, content:, published:)
      user = context[:current_user]
      note = user.notes.create!(title: title, content: content, published: published)

      { note: note }
    end
  end
end
