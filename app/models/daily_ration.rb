class DailyRation < ActiveRecord::Base
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }

  belongs_to :users
  belongs_to :daily_menus
  belongs_to :sprints
  belongs_to :dishes
end
