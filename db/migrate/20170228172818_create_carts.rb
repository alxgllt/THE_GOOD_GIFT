class CreateCarts < ActiveRecord::Migration[5.0]
  def change
    create_table :carts do |t|
      t.string :gender
      t.integer :price
      t.string :name
      t.string :tags, array: true, null: false, default: []

      t.timestamps
    end
  end
end
