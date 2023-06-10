# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  content    :text
#  published  :boolean
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_notes_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class NoteSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :content, :published, :created_at, :updated_at
  belongs_to :user

  cache_options enabled: true, cache_length: 12.hours
end
