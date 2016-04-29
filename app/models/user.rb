class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


  validates :username, :presence => true, :uniqueness => true
  validates_format_of :username, with: /\A[a-zA-Z0-9_\.]*\z/

  has_many :reflections


  extend FriendlyId
  friendly_id :username, :use => :history

  def should_generate_new_friendly_id?
    username_changed?
  end


  def current_streak
    days_reflected = reflections.order("created_at DESC").pluck(:created_at).map(&:to_date).uniq
    streak = 0
    days_reflected.each_with_index do | d, index |
      if d >= (index +1).days.ago.to_date
        streak += 1
      else
        break
      end
    end
    streak
  end

end #final
