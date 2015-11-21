require 'grape'

module API
  module Version1
    class Sprints < ::Grape::API
      version 'v1', using: :path

      resource :sprints do
        desc 'Returns sprints that are running or being closed', headers: {
          'X-Auth-Token' => {
            description: 'User token',
            required: true
          }
        }

        get '/' do
          authenticate_by_token!
          Sprint.where(state: ['running', 'closed'])
        end

        desc 'Creates order', headers: {
          'X-Auth-Token' => {
            description: 'User token',
            required: true
          }
        }

        params do
          requires :days, type: Hash do
            requires type: Hash, desc: "Dishes list filtered by days"
          end
        end

        post '/:id/daily_rations' do
          authenticate_by_token!

          sprint = Sprint.find(params[:id])
          user_id = current_user.id
          dishes = Dish.select(:id, :price).as_json
          # Convert dishes to the hash (:dish_id => :price)
          # To optimize amount of db requests
          dishes_hash = Hash[dishes.map(&:values).map(&:flatten)]

          daily_menus = DailyMenu.select(:id, :max_total).as_json
          # Convert daily menus to the hash (:id => :max_total)
          daily_menus_hash = Hash[daily_menus.map(&:values).map(&:flatten)]

          daily_rations = []
          params[:days].each do |day|
            total_price = 0
            # Get daily menu id from the hash
            daily_menu_id = day[0].to_i
            # Iterate through dish => quanity hash
            # Break if one of the total prices is bigger than day's
            break unless day[1].each do |dish|
              # Get dish id and its quanity from the dishes array
              dish_id = dish[0].to_i
              dish_quantity = dish[1].to_i
              # Get dish price from tha hash
              dish_price = dishes_hash[dish_id]
              total_price += dish_price
              # Check if total price is bigger than day limit
              if total_price >= daily_menus_hash[daily_menu_id]
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
          DailyRation.import daily_rations, validate: true if daily_rations
        end

        desc 'Returns sprint by id', headers: {
          'X-Auth-Token' => {
            description: 'User token',
            required: true
          }
        }

        get '/:id' do
          authenticate_by_token!
          Sprint.find(params[:id])
        end
      end
    end
  end
end
