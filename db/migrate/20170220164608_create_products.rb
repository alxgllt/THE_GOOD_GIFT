class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :brand
      t.string :name
      t.integer :price
      t.text :description
      t.string :description_short
      t.string :image
      t.string :tag_one
      t.string :tag_two
      t.integer :sell_priority
      t.string :gender
      t.boolean :online_supplied
      t.integer :stock
      t.boolean :availability

      t.timestamps
    end
  end
end
