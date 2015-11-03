FactoryGirl.define do
  factory :sprint do
    title 'First sprint'
    started_at DateTime.civil(2007, 12, 4, 0, 0, 0, 0)
    closed_at DateTime.civil(2007, 12, 11, 0, 0, 0, 0)
  end
end
