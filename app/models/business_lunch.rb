class BusinessLunch < Dish
  validates :children_ids, presence: true
  before_save :delete_nils_in_children_ids

  private

    def  delete_nils_in_children_ids
      self.children_ids = self.children_ids.select { |item| !item.nil? }
    end
end
