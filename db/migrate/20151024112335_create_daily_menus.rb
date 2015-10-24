class CreateDailyMenus < ActiveRecord::Migration
  def change
    create_table :daily_menus do |t|
      t.integer :day_number
      t.float :max_total
      t.integer :dish_ids, default: [], array: true
      t.timestamps null: false
    end

    add_index :daily_menus, [:dish_ids],
      name: "index_daily_menus_on_dish_ids", using: :gin
  end
end
