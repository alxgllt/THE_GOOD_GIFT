class Cart < ApplicationRecord
  has_many :cart_products
  has_many :products, through: :cart_products

  def include?(product)
    self.products.each do |prod|
      return true if prod == product
    end
    return false
  end

  def gift_number_range
    if self.price < 600
      return [2, 3]
    else
      return [2, 3, 4]
    end
  end

  def total
    products.sum(:price_cents) / 100
  end
end
