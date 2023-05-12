module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def resolve(**params)
      begin
        execute(**params)
      rescue ActiveRecord::RecordInvalid => e
        handle_exception(e, 422, :unprocessable_entity)
      rescue ActiveRecord::RecordNotFound => e
        handle_exception(e, 404, :not_found)
      rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordNotSaved => e
        handle_exception(e, 422, :unprocessable_entity)
      rescue ActiveRecord::RecordNotDestroyed => e
        handle_exception(e, 422, :unprocessable_entity)
      rescue NotAuthorized => e
        handle_exception(e, 401, :unauthorized)
      rescue GraphQL::ExecutionError => e
        handle_exception(e, 422, :unprocessable_entity)
      rescue StandardError => e
        handle_exception(e, 500, :internal_server_error)
      end
    end

    def handle_exception(exception, code, status)
      error_message = exception.respond_to?(:record) ? exception.record.errors.full_messages.to_sentence : exception.message
      GraphQL::ExecutionError.new(error_message, extensions: { status: code, error: status })
    end

    def authorize(note)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "You are not authorized to perform this action" unless note.user_id == user.id || user.admin?
  end

    class NotAuthorized < StandardError; end
  end
end
