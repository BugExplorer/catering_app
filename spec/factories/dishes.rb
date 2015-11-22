FactoryGirl.define do
  factory :dish, class: 'Dish' do
    title 'Hamburger'
    description 'Description'
    price 1.2
    association :category
  end
end
