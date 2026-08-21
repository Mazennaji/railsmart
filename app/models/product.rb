class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :restrict_with_error
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_fill: [400, 400]
    attachable.variant :detail, resize_to_limit: [800, 800]
  end

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :in_stock, -> { where("stock > 0") }
  scope :search,      ->(term)  { where("name ILIKE ?", "%#{term}%") if term.present? }
  scope :by_category, ->(id)    { where(category_id: id) if id.present? }
  scope :min_price,   ->(value) { where("price >= ?", value) if value.present? }
  scope :max_price,   ->(value) { where("price <= ?", value) if value.present? }

  SORTS = {
    "name"        => { name: :asc },
    "price_asc"   => { price: :asc },
    "price_desc"  => { price: :desc },
    "newest"      => { created_at: :desc }
  }.freeze

  def self.sorted_by(key)
    order(SORTS.fetch(key, SORTS["name"]))
  end

  def image?
    image.attached?
  end
end