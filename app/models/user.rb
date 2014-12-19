class User < ActiveRecord::Base
  has_many :posts
  has_many :comments

  has_secure_password validates: false

  validates :username, presence: true, uniqueness: true
  validates :password, on: :create, length: {minimum: 5}
end