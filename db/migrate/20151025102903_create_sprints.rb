class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.string :title, limit: 45
      t.datetime :started_at
      t.datetime :closed_at
      t.string :state
      t.timestamps null: false
    end
  end
end
