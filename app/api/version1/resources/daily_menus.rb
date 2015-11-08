require 'grape'

module API
  module Version1
    class DailyMenus < ::Grape::API
      version 'v1', using: :path

      resource :daily_menus do
        desc 'Returns daily menus, with categories that has dishes', headers: {
          'X-Auth-Token' => {
            description: 'User token',
            required: true
          }
        }

        get '/' do
          response = DailyMenu.all.as_json(except: [:created_at, :updated_at])
          categories = Category.all
                       .as_json(except: [:created_at, :updated_at])
          response.each do |resp|
            # Create categories array node for each DailyMenu
            resp['categories'] = categories
            # Create dishes array node for each Category
            dishes = Dish.find(resp['dish_ids'])
            resp['categories'].each do |category|
              category['dishes'] =
                dishes
                .select { |dish| dish.category_id == category['id'] }
                .as_json(except: [:sort_order, :created_at, :updated_at])
            end
            # There are no sense to store dish_ids
            resp.delete('dish_ids')
          end
        end
      end
    end
  end
end
