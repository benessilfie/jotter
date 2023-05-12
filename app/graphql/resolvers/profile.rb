class Resolvers::Profile < Resolvers::Base
  type Types::UserType, null: true

  def resolve()
    context[:current_user]
  end
end
