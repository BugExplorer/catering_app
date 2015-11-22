require 'rails_helper'

RSpec.describe SingleMeal, type: :model do
  it 'is valid with a title, description and price' do
    expect(FactoryGirl.build(:single_meal)).to be_valid
  end

  it 'is valid without a description' do
    single_meal = FactoryGirl.build(:single_meal, description: nil)
    expect(single_meal).to be_valid
  end

  it 'is valid with long description' do
    single_meal = FactoryGirl.build(:single_meal, description: 'a' * 50)
    expect(single_meal).to be_valid
  end

  it 'is invalid without a title' do
    single_meal = FactoryGirl.build(:single_meal, title: nil)
    expect(single_meal).not_to be_valid
  end

  it 'is invalid without a price' do
    single_meal = FactoryGirl.build(:single_meal, price: nil)
    expect(single_meal).not_to be_valid
  end

  it 'is invalid with long title' do
    single_meal = FactoryGirl.build(:single_meal, title: 'a' * 50)
    expect(single_meal).not_to be_valid
  end
end
