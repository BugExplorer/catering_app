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

          sprint_id = Sprint.find(params[:id]).id
          user_id   = current_user.id

          daily_rations = params[:days].map do |day|
            # get daily menu id from the hash
            daily_menu_id = day[0].to_i
            # iterate through dish => quanity hash
            day[1].map do |dish|
              # get dish id and his quanity from the dishes array
              dish_id  = dish[0]
              quantity = dish[1]
              dish_price = Dish.find(dish_id).price
              DailyRation.new(price: dish_price,
                              quantity: quantity,
                              user_id: user_id,
                              daily_menu_id: daily_menu_id,
                              sprint_id: sprint_id,
                              dish_id: dish_id)
            end
          end
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
