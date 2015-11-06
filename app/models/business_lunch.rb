class BusinessLunch < Dish
  validates :children_ids, presence: true

  # Multiply select can return an empty elements, so we need to reject them.
  before_validation do |model|
    model.children_ids.reject!(&:blank?) if model.children_ids
  end
end
