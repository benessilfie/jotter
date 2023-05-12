class Resolvers::ViewNote < Resolvers::Base
  type Types::NoteType, null: true

  argument :id, ID, required: true

  def resolve(id:)
    user = context[:current_user]
    handle_unauthenticated_error if user.nil?

    begin
      note = user&.admin? ? Note.find(id) : user.notes.find(id)
      note

      rescue ActiveRecord::RecordNotFound
        handle_record_not_found_error(id)
    end
  end
end
