# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  auth_token      :string
#  email           :string
#  password_digest :string
#  role            :integer          default("member")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email, :role, :created_at, :updated_at
  has_many :notes

  cache_options enabled: true, cache_length: 12.hours
end
