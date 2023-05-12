  class Resolvers::ViewNotes < Resolvers::Base
    type [Types::NoteType], null: true

    def resolve()
      user = context[:current_user]
      handle_unauthenticated_error if user.nil?

      notes = user.admin? ? Note.all : user.notes

      notes
    end
  end
