class DeleteOldPriceFromProduct < ActiveRecord::Migration[5.0]
  def change
    change_table :products do |t|
    t.remove :price
  end
end
end
