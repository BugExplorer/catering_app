require 'rails_helper'

RSpec.describe Category, type: :model do
  it "is valid with a title and sort order" do
    expect(FactoryGirl.build(:category)).to be_valid
  end

 it "is invalid without a title" do
    category = FactoryGirl.build(:category, title: nil)
    expect(category).not_to be_valid
  end

  it "is invalid without a sort order" do
    category = FactoryGirl.build(:category, sort_order: nil)
    expect(category).not_to be_valid
  end

  it "is invalid with long title" do
    single_meal = FactoryGirl.build(:single_meal, title: "a" * 50)
    expect(single_meal).not_to be_valid
  end
end
