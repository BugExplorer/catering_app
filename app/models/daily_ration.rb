class DailyRation < ActiveRecord::Base
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }

  has_many :users
  has_many :daily_menus
  has_many :sprints
  has_many :dishes
end
