class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :customer_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  STATUSES = %w[pending paid shipped cancelled].freeze
  validates :status, inclusion: { in: STATUSES }

  after_initialize :set_default_status, if: :new_record?

  def recalculate_total!
    update!(total: order_items.sum { |item| item.price * item.quantity })
  end

  private

  def set_default_status
    self.status ||= "pending"
  end
end