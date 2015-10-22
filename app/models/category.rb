class Category < ActiveRecord::Base
  validates :title, presence: true, length: { maximum: 45 }
  validates :sort_order, presence: true

  has_many :dishes, dependent: :destroy
end
