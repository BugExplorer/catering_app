ActiveAdmin.register BusinessLunch do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
   permit_params :title, :description, :price, children_ids: []
# #
# or
#
  # permit_params do
  #   permitted = [:title, :description, :price]
  #   permitted << :children_ids
  #   puts permitted
  #   permitted
  # end

  # params[:business_lunch][:children_ids] = Array.wrap(params[:business_lunch][:children_ids]).map!(&:to_i)


  # attr_accessor   :names_raw

  # def names_raw
  #   self.names.join("\n") unless self.names.nil?
  # end

  form do |f|
    f.inputs "Business Lunch" do
      f.input :title
      f.input :description, as: :text, required: false
      f.input :price
      f.input :children_ids, as: :select, input_html: { :multiple => true },
                             collection: SingleMeal.all
    end
    f.actions
  end

end
