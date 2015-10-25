require 'rails_helper'

RSpec.describe DailyRation, type: :model do
  it "is valid with a price and quantity" do
    expect(FactoryGirl.build(:daily_ration)).to be_valid
  end

  it "is invalid without a price" do
    expect(FactoryGirl.build(:daily_ration, price: nil)).not_to be_valid
  end

  it "is invalid without a quantity" do
    expect(FactoryGirl.build(:daily_ration, quantity: nil)).not_to be_valid
  end

  it "is invalid with a negative price" do
    expect(FactoryGirl.build(:daily_ration, price: -5)).not_to be_valid
  end

  it "is invalid with a negative quantity" do
    expect(FactoryGirl.build(:daily_ration, quantity: -3)).not_to be_valid
  end
end
