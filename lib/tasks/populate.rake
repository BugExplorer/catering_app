require 'populator'
require 'faker'

namespace :populate do
  desc 'Create random categories'
  task categories: [:environment] do
    Category.populate(4) do |category|
      category.title = Faker::Address.city
    end
    Category.populate(1) do |category|
      category.title = "Lunches"
    end
  end

  desc 'Create random single_meal'
  task single_meal: [:environment] do
    categories = Category.all.pluck(:id)
    SingleMeal.populate(15..25) do |dish|
      dish.title       = Faker::Company.name
      dish.description = Faker::Lorem.sentence(5)
      dish.price       = rand(100)
      dish.type        = 'SingleMeal'
      dish.category_id = categories.sample 1
    end
  end

  desc 'Create random business lunch'
  task bussines_lunch: [:environment] do
    number = 0
    meals = SingleMeal.all.pluck(:id, :price)
    BusinessLunch.populate 7 do |bd|
      bd.title        = Faker::Book.title
      bd.description  = Faker::Lorem.sentence(5)
      bd.type         = 'BusinessLunch'
      bd.category_id  = 5

      childrens       = meals.sample(rand(2..5))
      bd.price        = childrens.reduce(0) { |m,i| m += i[1] }
      bd.children_ids = convert_to_pg_array childrens.map { |i| i[0] }
    end
  end

  desc 'Create random sprints'
  task sprints: [:environment] do
    number = 0
    Sprint.populate 6 do |sprint|
      sprint.state      = 'pending'
      sprint.started_at = Date.commercial(2015, 44 + number)
      number += 1
      sprint.closed_at  = Date.commercial(2015, 44 + number)
      sprint.title      = "Sprint # #{number}"
    end
    temp = Sprint.where(state: 'pending').first(2)
    temp.map { |x| x.run }
    temp.map { |x| x.save }
    closed = Sprint.where(state: 'running').first(2)
    closed.map { |x| x.close }
    closed.map { |x| x.save }
  end

  desc 'Create random daily menus'
  task daily_menus: [:environment] do
    number = 0
    dishes = Dish.all.pluck(:id)
    DailyMenu.populate 7 do |dm|
      dm.day_number = number
      dm.dish_ids   = convert_to_pg_array dishes.sample 15
      dm.max_total  = 100..150
      number += 1
    end
  end

  desc 'Create random users'
  task users: [:environment] do
    password = 'useruser'
    User.populate(5) do |user|
      user.email                = Faker::Internet.safe_email
      user.name                 = Faker::Name.name
      user.encrypted_password   = password
      user.sign_in_count        = 0
      user.authentication_token = Faker::Bitcoin.address
    end
  end

  desc 'Create categories, meals, bussines lunches, sprints, daily menus, users'
  task all: [:environment] do
    Rake::Task['populate:categories'].invoke
    puts 'Categories populated'
    Rake::Task['populate:single_meal'].invoke
    puts 'Single meals populated'
    Rake::Task['populate:bussines_lunch'].invoke
    puts 'Bussines lunches populated'
    Rake::Task['populate:sprints'].invoke
    puts 'Sprints populated'
    Rake::Task['populate:daily_menus'].invoke
    puts 'Daily menus populated'
    Rake::Task['populate:users'].invoke
    puts 'Users populated'
  end

  def convert_to_pg_array(array)
    array.to_s.tr('[', '{').tr(']', '}')
  end

  def find_price(array, id)
    array.detect { |i| i[0] == id }
  end
end
