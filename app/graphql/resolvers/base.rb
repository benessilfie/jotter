class Resolvers::Base < GraphQL::Schema::Resolver
  def handle_record_not_found_error(id)
    raise GraphQL::ExecutionError.new("Unable to find Note with ID '#{id}' for user with ID '#{context[:current_user].id}'", extensions: { status: 404, error: "not_found" })
  end

  def handle_unauthenticated_error
    raise GraphQL::ExecutionError.new("You must be authenticated to view this Note", extensions: { status: 401, error: "unauthorized" })
  end
end
