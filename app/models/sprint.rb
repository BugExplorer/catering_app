class Sprint < ActiveRecord::Base
  include AASM

  validates :title, presence: true, length: { maximum: 45 }
  validates :started_at, presence: true
  validates :closed_at, presence: true
  validates :state, presence: true

  has_many :daily_rations

  default_scope -> { order(id: :asc) }

  aasm column: 'state' do
    state :pending, initial: true
    state :running
    state :closed

    event :run do
      transitions from: :pending, to: :running
    end

    event :close do
      transitions from: :running, to: :closed
    end
  end
end
