class NotesController < ApplicationController
  before_action :set_note, :check_owner, only: %i[show update destroy]
  before_action :user_signed_in?, only: %i[create]

  def index
    @notes = current_user.admin? ? Note.all : current_user.notes
    render json: NoteSerializer.new(@notes).serializable_hash, status: :ok
  end

  def show
    options = { include: [:user] }
    render json: NoteSerializer.new(@note, options).serializable_hash, status: :ok
  end

  def create
    @note = current_user.notes.build(note_params)

    if @note.save
      render json: NoteSerializer.new(@note).serializable_hash, status: :created
    else
      render json: { errors: @note.errors.full_messages }, status: :bad_request
    end
  end

  def update
    if @note.update(note_params)
      render json: NoteSerializer.new(@note).serializable_hash, status: :ok
    else
      render json: { errors: @note.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    @note.destroy
    head :no_content
  end

  private

    def note_params
      params.permit(:title, :content, :published)
    end

    def set_note
      @note = Note.find_by(id: params[:id])
      render json: { errors: ["Note with ID '#{params[:id]}' not found"] }, status: :not_found unless @note
    end

    def check_owner
      return true if current_user&.admin?

      if @note.user_id != current_user&.id
        render json: { errors: ["You are not authorized to perform this action"] }, status: :unauthorized
      end
    end
end
