class NoteSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :content, :published, :created_at, :updated_at
  belongs_to :user

  cache_options enabled: true, cache_length: 12.hours
end
