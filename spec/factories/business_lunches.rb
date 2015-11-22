FactoryGirl.define do
  factory :business_lunch, parent: :dish, class: 'BusinessLunch' do
    type 'BusinessLunch'
    category
  end
end
