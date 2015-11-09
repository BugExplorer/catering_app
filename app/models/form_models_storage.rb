class FormModelsStorage
  # Returns DailyMenus, where each day has categorized dishes
  def self.get_data
    menus = DailyMenu.all.as_json(except: [:created_at, :updated_at])
    categories = Category.all

    menus.each do |menu|
      menu_categories = categories.as_json(except: [:created_at, :updated_at])

      dishes = Dish.find(menu['dish_ids'])
      grouped_dishes = dishes.group_by { |d| d['category_id'] }

      # Create categories array node for each DailyMenu
      menu['categories'] = menu_categories
      menu['categories'].each do |category|
        category['dishes'] =
          grouped_dishes[category['id']]
          .as_json(except: [:sort_order, :created_at, :updated_at])
      end

      # Delete empty categories
      menu['categories'].reject! { |cat| !cat['dishes'] }
      # There are no sense to store dish_ids
      menu.delete('dish_ids')
    end

    menus
  end
end
