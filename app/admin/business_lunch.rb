ActiveAdmin.register BusinessLunch do

  permit_params :title, :description, :price, :category_id, children_ids: []

  form do |f|
    f.inputs "Business Lunch" do
      f.input :title
      f.input :description, as: :text, required: false
      f.input :price
      f.input :children_ids, as: :select, multiple: true,
                             collection: SingleMeal.all
      f.input :category, as: :select, collection: Category.all
    end
    f.actions
  end
end
