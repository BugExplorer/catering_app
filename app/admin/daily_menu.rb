ActiveAdmin.register DailyMenu do

  permit_params :day_number, :max_total, dish_ids: []

  form do |f|
    f.inputs "Business Lunch" do
      f.input :day_number
      f.input :max_total
      f.input :dish_ids, as: :select, input_html: { multiple: true },
                         collection: Dish.all
    end
    f.actions
  end

end
