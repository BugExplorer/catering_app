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
          dishes = Dish.select(:id, :price).as_json
          # Convert dishes to the hash (:dish_id => :price)
          # To optimize amount of db requests
          dishes_hash = Hash[dishes.map(&:values).map(&:flatten)]
          user_id = current_user.id

          daily_rations = []
          params[:days].each do |day|
            # Get daily menu id from the hash
            daily_menu_id = day[0].to_i
            # Iterate through dish => quanity hash
            daily_rations = day[1].map do |dish|
              # Get dish id and his quanity from the dishes array
              dish_id = dish[0]
              dish_quantity = dish[1]
              # Get dish price from tha hash
              dish_price = dishes_hash[dish_id]
              DailyRation.new(daily_menu_id: daily_menu_id,
                              dish_id:       dish_id,
                              price:         dish_price,
                              quantity:      dish_quantity,
                              user_id:       user_id,
                              sprint_id:     sprint.id)
            end
          end

          # Push that as one db request
          DailyRation.import daily_rations, validate: true
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
