class NoteUpdater < ApplicationService
  def initialize(note, note_params = {})
    @note = note
    @title = note_params[:title] || @note.title
    @content = note_params[:content] || @note.content
    @published = note_params[:published].nil? ? @note.published : note_params[:published]
  end

  def call
    update_note
  end

  private

    def update_note
      @note.update!(
        title: @title,
        content: @content,
        published: @published
      )
    end
end
