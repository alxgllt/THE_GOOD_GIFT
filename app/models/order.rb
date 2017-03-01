class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items
  monetize :total_price_cents
  validates :email, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "Format email non valide." }, allow_nil: true
  validates :phone, format: { with: /\b\d{3}[-.]?\d{3}[-.]?\d{4}\b/, message: "Format de téléphone non valide." }, allow_nil: true
end
