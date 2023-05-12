class User < ApplicationRecord
  has_secure_password
  has_many :notes, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates_with EmailAddress::ActiveRecordValidator, field: :email
  validates :password_digest, presence: true

  enum role: { admin: 0, member: 1 }

  def token
    self.update(auth_token: JsonWebToken.encode(user_id: self.id))
    self.auth_token
  end
end
