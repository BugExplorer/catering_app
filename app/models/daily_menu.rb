class DailyMenu < ActiveRecord::Base
  validates :day_number, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :max_total, numericality: { greater_than_or_equal_to: 0 }
  validates :dish_ids, presence: true

  belongs_to :daily_ration

  before_save :delete_nils_in_dish_ids

  private

    def delete_nils_in_dish_ids
      self.dish_ids = self.dish_ids.select { |item| !item.nil? }
    end
end
