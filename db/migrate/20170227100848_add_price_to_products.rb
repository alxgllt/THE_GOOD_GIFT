class AddPriceToProducts < ActiveRecord::Migration[5.0]
  def change
    add_monetize :products, :price, currency: { present: false }
  end
end
