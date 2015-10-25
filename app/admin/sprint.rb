ActiveAdmin.register Sprint do
  permit_params :title, :started_at, :closed_at, :state

  form do |f|
    f.inputs "Daily Ration" do
      f.input :title
      f.input :started_at
      f.input :closed_at
      f.input :state, as: :select, collection: ["pending", "running", "closed"]
    end
    f.actions
  end
end
