module API
  module Version1
    module QueryHelpers
      # Returns DailyMenus, where each day has categorized dishes
      def get_daily_categorized_dishes
        menus = DailyMenu.all.as_json(except: [:created_at, :updated_at])
        categories = Category.all
        dishes_collection = Dish.all.to_a

        menus.each do |menu|
          menu_categories = categories.as_json(except: [:created_at, :updated_at])

          dishes = dishes_collection.select do |d|
            menu['dish_ids'].include? d.id
          end
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

      # Validate and save order as one db request
      def save_order!(sprint)
        user_id = current_user.id
        dishes = Dish.select(:id, :price).to_a
        daily_menus = DailyMenu.select(:id, :max_total).to_a

        daily_rations = []
        params[:days].each do |day|
          total_price = 0
          # Get daily menu id from the hash
          daily_menu_id = day[0].to_i
          daily_menu = daily_menus.find { |d| d.id == daily_menu_id }
          # Iterate through day's dishes
          # Break if one of the total prices is bigger than day's
          break unless day[1].each do |dish|
            dish = dish[1]
            dish_id = dish['dish_id'].to_i
            dish_quantity = dish['quantity'].to_i

            # Get the dish the form array
            dish_price = dishes.find { |d| d.id == dish_id }.price
            dish_price = dish_price * dish_quantity
            total_price += dish_price
            # Check if total price is bigger than day limit
            if total_price >= daily_menu.max_total || dish_quantity < 1
              daily_rations = nil
              break
            else
              daily_rations << DailyRation.new(daily_menu_id: daily_menu_id,
                                               dish_id:       dish_id,
                                               price:         dish_price,
                                               quantity:      dish_quantity,
                                               user_id:       user_id,
                                               sprint_id:     sprint.id)
            end
          end
        end
        # Push that as one db request
        if daily_rations
          request = DailyRation.import daily_rations, validate: true
          unless request.failed_instances.empty?
            error!({ error_code: 400,
                     error_message: 'Order error!' }, 400)
          end
        else
          error!({ error_code: 400,
                   error_message: 'Total price is bigger than limit!' }, 400)
        end

      end
    end
  end
end
