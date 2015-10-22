class Dish < ActiveRecord::Base
  validates :title, presence: true, length: { maximum: 45 }
  validates :price, presence: true

  # belongs_to :category
end
