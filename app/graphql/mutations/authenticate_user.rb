module Mutations
  class AuthenticateUser < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: true

    def execute(email:, password:)
      user = User.find_by_email!(email)

      if user&.authenticate(password)
        { token: user.token }
      else
        raise GraphQL::ExecutionError, "Invalid credentials"
      end
    end
  end
end
