class ChangeTotalpriceToOrders < ActiveRecord::Migration[5.0]
  def change
    change_table :orders do |t|
      t.remove :total_price
      t.monetize :total_price, currency: { present: false }
    end
  end
end
