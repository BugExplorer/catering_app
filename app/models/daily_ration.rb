class DailyRation < ActiveRecord::Base
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }

  validates :user_id, numericality: { greater_than_or_equal_to: 1 }
  validates :dish_id, numericality: { greater_than_or_equal_to: 1 }
  validates :sprint_id, numericality: { greater_than_or_equal_to: 1 }
  validates :daily_menu_id, numericality: { greater_than_or_equal_to: 1 }

  belongs_to :user
  belongs_to :daily_menu
  belongs_to :sprint
  belongs_to :dish
end
