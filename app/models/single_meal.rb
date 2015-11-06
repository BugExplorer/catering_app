class SingleMeal < Dish
  validates :category, presence: true

  def children_ids
    nil
  end
end
