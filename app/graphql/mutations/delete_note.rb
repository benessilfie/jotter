module Mutations
  class DeleteNote < BaseMutation
    argument :id, ID, required: true

    field :message, String, null: true

    def execute(id:)
      note = Note.find(id)
      authorize(note)

      note.destroy!
      { message: "Note deleted" }
    end
  end
end
