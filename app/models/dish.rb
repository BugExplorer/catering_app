class Dish < ActiveRecord::Base
  validates :title, presence: true, length: { maximum: 45 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :category
end
