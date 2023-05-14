module Mutations
  class CreateUser < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true
    argument :role, Types::RoleEnum, required: true

    field :user, Types::UserType, null: true

    def execute(email:, password:, role:)
      user = UserCreator.call(email: email, password: password, role: role)
      { user: user }
    end
  end
end
