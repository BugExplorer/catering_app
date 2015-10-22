require 'rails_helper'

RSpec.describe Dish, type: :model do
  it "is valid with a title, description and price" do
    expect(FactoryGirl.build(:dish)).to be_valid
  end

  it "is valid without a description" do
    dish = FactoryGirl.build(:dish, description: nil)
    expect(dish).to be_valid
  end

  it "is valid with long description" do
    dish = FactoryGirl.build(:dish, description: "a" * 50)
    expect(dish).to be_valid
  end

  it "is invalid without a title" do
    dish = FactoryGirl.build(:dish, title: nil)
    expect(dish).not_to be_valid
  end

  it "is invalid without a price" do
    dish = FactoryGirl.build(:dish, price: nil)
    expect(dish).not_to be_valid
  end

  it "is invalid with long title" do
    dish = FactoryGirl.build(:dish, title: "a" * 50)
    expect(dish).not_to be_valid
  end
end
