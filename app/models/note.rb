class Note < ApplicationRecord
  belongs_to :user

  validates :title, :content, presence: true
  validates :published, inclusion: { in: [true, false] }
end
