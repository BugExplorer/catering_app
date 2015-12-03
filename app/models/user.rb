class User < ActiveRecord::Base
  devise :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :database_authenticatable

  has_many :daily_rations
  scope :ordered,     -> (sprint_id) { find(find_rations(sprint_id)) }
  scope :not_ordered, -> (sprint_id) { where.not(id: find_rations(sprint_id)) }

  before_save :ensure_authentication_token

  def role?(r)
    role.include? r.to_s
  end

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def reset_authentication_token
    # Generate new token after user logs out. Just for security.
    # I don't think that after log out we'd set token as nil.
    self.authentication_token = generate_authentication_token
  end

  private

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end

    def self.find_rations(sprint_id)
      rations = DailyRation.includes(:user).where(sprint_id: sprint_id)
      users = rations.map { |ration| ration.user.id }.uniq
    end
end
