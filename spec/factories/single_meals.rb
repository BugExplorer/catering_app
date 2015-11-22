FactoryGirl.define do
  factory :single_meal, parent: :dish, class: 'SingleMeal' do
    type 'SingleMeal'
  end
end
