FactoryGirl.define do
  factory :daily_ration do
    price 2
    quantity 3
    association :user, factory: :user
    association :dish, factory: :dish
    association :sprint, factory: :sprint
    association :daily_menu, factory: :daily_menu
  end
end
