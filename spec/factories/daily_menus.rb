FactoryGirl.define do
  factory :daily_menu do
    day_number 1
    max_total 15
    dish_ids [1, 2]
  end
end
