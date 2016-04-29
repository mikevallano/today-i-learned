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

  def last_reflection_date
    reflections.last.created_at.to_date.stamp("June 1st")
  end

  def reflected_today?
    reflections.last.created_at.to_date == Date.today
  end

  def current_streak
    days_reflected = reflections.order("created_at DESC").pluck(:created_at).map(&:to_date).uniq
    streak = 0
    day_counter = days_reflected.first
    if days_reflected.first < 1.day.ago.to_date
      streak
    else
      days_reflected.each do |d|
        if d == day_counter
          streak += 1
          day_counter = day_counter.yesterday.to_date
        else
          break
        end
      end
    end
    streak
  end #current_streak

end #final
