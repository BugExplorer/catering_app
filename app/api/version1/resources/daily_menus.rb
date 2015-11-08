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
          menus = DailyMenu.all.as_json(except: [:created_at, :updated_at])
          menus.each do |resp|
            categories = Category.all
                         .as_json(except: [:created_at, :updated_at])

            dishes = Dish.find(resp['dish_ids'])
            grouped_dishes = dishes.group_by { |d| d['category_id'] }

            # Create categories array node for each DailyMenu
            resp['categories'] = categories
            resp['categories'].each do |category|
              category['dishes'] =
                grouped_dishes[category['id']]
                .as_json(except: [:sort_order, :created_at, :updated_at])
            end

            # Delete empty categories
            resp['categories'].reject! { |cat| !cat['dishes'] }
            # There are no sense to store dish_ids
            resp.delete('dish_ids')
          end
        end
      end
    end
  end
end
