require 'rails_helper'

RSpec.describe Sprint, type: :model do
  it 'is valid with a title, started and closed at' do
    expect(FactoryGirl.build(:sprint)).to be_valid
  end

  it 'is has initial state' do
    expect(FactoryGirl.build(:sprint).state).to eq('pending')
  end

  it 'changes state' do
    sprint = FactoryGirl.create(:sprint)
    sprint.run!
    expect(sprint.state).to eq('running')
  end

  it 'is invalid without a title' do
    expect(FactoryGirl.build(:sprint, title: nil)).not_to be_valid
  end

  it 'is invalid with a long title' do
    expect(FactoryGirl.build(:sprint, title: 'a' * 50)).not_to be_valid
  end

  it 'is invalid without a started_at time' do
    expect(FactoryGirl.build(:sprint, started_at: nil)).not_to be_valid
  end

  it 'is invalid without a closed_at time' do
    expect(FactoryGirl.build(:sprint, closed_at: nil)).not_to be_valid
  end
end
