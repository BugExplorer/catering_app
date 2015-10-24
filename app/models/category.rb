class Category < ActiveRecord::Base
  validates :title, presence: true, length: { maximum: 45 }
  validates :sort_order, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_many :dishes, dependent: :destroy
end
