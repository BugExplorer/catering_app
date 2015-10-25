class CreateDishes < ActiveRecord::Migration
  def change
    create_table :dishes do |t|
      t.string  :title, limit: 45
      t.integer :sort_order
      t.text    :description
      t.float   :price
      t.string  :type, limit: 45
      t.integer :children_ids, default: [], array: true
      t.integer :category_id
      t.timestamps null: false
    end

    add_index :dishes, [:children_ids],
      name: "index_dishes_on_children_ids", using: :gin
    add_index :dishes, [:category_id]
  end
end
