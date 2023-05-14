class NoteCreator < ApplicationService
  def initialize(user, notes_params = {})
    @user = user
    @title = notes_params[:title]
    @content = notes_params[:content]
    @published = notes_params[:published]
  end

  def call
    create_note
  end

  private

    def create_note
      Note.create!(user: @user, title: @title, content: @content, published: @published)
    end
end
