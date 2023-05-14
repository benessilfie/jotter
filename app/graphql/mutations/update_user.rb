module Mutations
  class UpdateUser < BaseMutation
    argument :email, String, required: false
    argument :role, Types::RoleEnum, required: false

    field :user, Types::UserType, null: true

    def execute(email: nil, role: nil)
      user = context[:current_user]
      UserUpdater.call(user, email: email, role: role)

      { user: user }
    end
  end
end
