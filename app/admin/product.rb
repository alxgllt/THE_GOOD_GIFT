ActiveAdmin.register Product do

  permit_params :brand, :name, :price_cents, :description, :description_short, :image, :tag_one, :tag_two, :sell_priority, :gender, :online_supplied, :stock, :availability, :supplier_name

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


end
