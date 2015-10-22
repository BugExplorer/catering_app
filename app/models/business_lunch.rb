class BusinessLunch < Dish
  validates :children_ids, presence: true
end
