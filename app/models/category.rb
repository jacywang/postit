class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true, uniqueness: true
  before_save :generate_slug

  def generate_slug
    str = to_slug(self.name)
    category = Category.find_by(slug: str)
    count = 2
    while category && category != self
      str = append_suffix(str, count)
      category = Category.find_by(slug: str)
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

  def to_param
    self.slug
  end
end