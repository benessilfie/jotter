class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email, :role, :created_at, :updated_at
  has_many :notes

  cache_options enabled: true, cache_length: 12.hours
end
