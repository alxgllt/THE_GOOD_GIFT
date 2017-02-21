class ChangeImageToImagesForProducts < ActiveRecord::Migration[5.0]
  def change
    rename_column :products, :image, :images
    change_column :products, :images, 'json USING CAST(images AS json)'
  end
end
