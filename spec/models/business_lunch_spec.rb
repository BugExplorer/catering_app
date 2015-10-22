require 'rails_helper'

RSpec.describe BusinessLunch, type: :model do
  before :all do
    @dish_one = FactoryGirl.create(:single_meal)
    @dish_two = FactoryGirl.create(:single_meal, title: "Second")
  end

  it "is valid with a title, description and price" do
    business_lunch = FactoryGirl.build(:business_lunch)
    business_lunch.children_ids = [@dish_one.id, @dish_two.id]
    expect(business_lunch).to be_valid
  end

  it "is valid without a description" do
    business_lunch = FactoryGirl.build(:business_lunch, description: nil)
    business_lunch.children_ids = [@dish_one.id, @dish_two.id]
    expect(business_lunch).to be_valid
  end

  it "is valid with long description" do
    business_lunch = FactoryGirl.build(:business_lunch, description: "a" * 50)
    business_lunch.children_ids = [@dish_one.id, @dish_two.id]
    expect(business_lunch).to be_valid
  end

  it "is invalid without a title" do
    business_lunch = FactoryGirl.build(:business_lunch, title: nil)
    business_lunch.children_ids = [@dish_one.id, @dish_two.id]
    expect(business_lunch).not_to be_valid
  end

  it "is invalid without a price" do
    business_lunch = FactoryGirl.build(:business_lunch, price: nil)
    business_lunch.children_ids = [@dish_one.id, @dish_two.id]
    expect(business_lunch).not_to be_valid
  end

  it "is invalid with long title" do
    business_lunch = FactoryGirl.build(:business_lunch, title: "a" * 50)
    business_lunch.children_ids = [@dish_one.id, @dish_two.id]
    expect(business_lunch).not_to be_valid
  end
end
