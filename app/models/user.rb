class User < ActiveRecord::Base
  include Sluggable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validates: false

  validates :username, presence: true, uniqueness: true
  validates :password, on: :create, length: {minimum: 5}

  sluggable_column :username

  def admin?
    self.role == "admin"
  end

  def moderator?
    self.role == "moderator"
  end

  def two_factor_auth?
    !self.phone.nil?
  end

  def generate_pin!
    self.update_column(:pin, rand(10**6))
  end

end