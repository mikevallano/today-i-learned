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
    reflections.last.created_at.in_time_zone(time_zone).to_date.stamp("June 1st")
  end

  def reflected_today?
    last_reflection_date == Time.current.in_time_zone(time_zone).to_date.stamp("June 1st")
  end

  def current_streak
    days_reflected = reflections.order("created_at DESC").pluck(:created_at).map do |created_at|
      created_at.in_time_zone(time_zone).to_date
    end.uniq
    streak = 0
    day_counter = days_reflected.first
    if days_reflected.first <  Time.current.in_time_zone(time_zone).to_date.yesterday
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
