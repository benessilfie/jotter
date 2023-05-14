module Mutations
  class UpdateNote < BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: false
    argument :content, String, required: false
    argument :published, Boolean, required: false

    field :note, Types::NoteType, null: true

    def execute(id:, title:, content:, published:)
      note = Note.find(id)
      authorize(note)

      NoteUpdater.call(note, title: title, content: content, published: published)
      { note: note }
    end
  end
end
