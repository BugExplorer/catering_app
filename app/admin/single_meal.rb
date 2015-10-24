ActiveAdmin.register SingleMeal do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params :title, :description, :price, :category_id
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

  form do |f|
    f.inputs "Meal" do
      f.input :title
      f.input :description, as: :text, required: false
      f.input :price
      f.input :category, collection: Category.pluck(:title, :id)
    end
    f.actions
  end
end
