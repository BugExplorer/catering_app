require 'rails_helper'

RSpec.describe DailyMenu, type: :model do
  before :all do
    @dish_one = FactoryGirl.create(:single_meal)
    @dish_two = FactoryGirl.create(:single_meal, title: 'Second')
  end

  it 'is valid with a day number, max total and dish ids' do
    daily_menu = FactoryGirl.build(:daily_menu)
    daily_menu.dish_ids = [@dish_one.id, @dish_two.id]
    expect(daily_menu).to be_valid
  end

  it 'is invalid without a day number' do
    daily_menu = FactoryGirl.build(:daily_menu, day_number: nil)
    daily_menu.dish_ids = [@dish_one.id, @dish_two.id]
    expect(daily_menu).not_to be_valid
  end

  it 'is invalid with non-number day_number' do
    daily_menu = FactoryGirl.build(:daily_menu, day_number: 'not a number')
    daily_menu.dish_ids = [@dish_one.id, @dish_two.id]
    expect(daily_menu).not_to be_valid
  end

  it 'is invalid without a max total' do
    daily_menu = FactoryGirl.build(:daily_menu, max_total: nil)
    daily_menu.dish_ids = [@dish_one.id, @dish_two.id]
    expect(daily_menu).not_to be_valid
  end

  it 'is invalid with non-number max total' do
    daily_menu = FactoryGirl.build(:daily_menu, max_total: 'not a number')
    daily_menu.dish_ids = [@dish_one.id, @dish_two.id]
    expect(daily_menu).not_to be_valid
  end

  it 'is invalid without any dish ids' do
    daily_menu = FactoryGirl.build(:daily_menu)
    daily_menu.dish_ids = nil
    expect(daily_menu).not_to be_valid
  end
end
