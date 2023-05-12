module Mutations
  class DeleteUser < BaseMutation
    argument :password, String, required: true

    field :message, String, null: true

    def execute(password:)
      user = context[:current_user]

      if user&.authenticate(password)
        user.destroy!
      else
        raise NotAuthorized, "Invalid credentials"
      end

      { message: "User deleted" }
    end
  end
end
