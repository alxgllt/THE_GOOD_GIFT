class Product < ApplicationRecord
  has_many :order_items
  has_many :orders, through: :order_items

  belongs_to :product_list
  monetize :price_cents  # or :price_pennies

  mount_uploader :image, ImageUploader
end
