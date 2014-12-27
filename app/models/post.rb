class Post < ActiveRecord::Base
  include Voteable
  
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: {minimum: 5}
  validates :url, presence: true, uniqueness: true
  validates :description, presence: true

  before_save :generate_slug

  def to_param
    self.slug
  end

  def generate_slug
    str = to_slug(self.title)
    post = Post.find_by(slug: str)
    count = 2
    while post && post != self
      str = append_suffix(str, count)
      post = Post.find_by(slug: str)
      count += 1
    end
    self.slug = str
  end

  def append_suffix(str, count)
    if str.split("-").last.to_i != 0 
      return str.split("-").slice(0...-1).join("-") + "-" + count.to_s
    else
      return str + "-" + count.to_s
    end
  end

  def to_slug(name)
    str = name.strip
    str.gsub!(/\s*[^a-zA-Z0-9]\s*/, "-")
    str.gsub!(/-+/, "-")
    str.downcase
  end
end