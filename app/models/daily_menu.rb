class DailyMenu < ActiveRecord::Base
  validates :day_number, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :max_total, numericality: { greater_than_or_equal_to: 0 }
  validates :dish_ids, presence: true

  # Multiply select can return an empty elements, so we need to reject them.
  before_validation do |model|
    model.dish_ids.reject!(&:blank?) if model.dish_ids
  end

  default_scope -> { order(day_number: :asc) }
end
