class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validates: false

  validates :username, presence: true, uniqueness: true
  validates :password, on: :create, length: {minimum: 5}

  before_save :generate_slug

  def generate_slug
    str = to_slug(self.username)
  end

  def to_slug(name)
    str = name.strip
    str.gsub!(/\s*[^a-zA-Z0-9]\s*/, "-")
    str.gsub!(/-+/, "-")
    str.downcase
  end

  def to_param
    self.slug
  end
end