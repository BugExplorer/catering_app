require 'faker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    name "User"
    password 'password'
    password_confirmation 'password'
  end
end
