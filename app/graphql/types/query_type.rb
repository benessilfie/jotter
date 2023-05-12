module Types
  class QueryType < Types::BaseObject
    field :profile, resolver: Resolvers::Profile
    field :view_notes, resolver: Resolvers::ViewNotes
    field :view_note, resolver: Resolvers::ViewNote
  end
end
