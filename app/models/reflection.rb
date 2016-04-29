class Reflection < ActiveRecord::Base
  belongs_to :user

  validates :body, :presence => true,
  :length => {
    :maximum   => 300,
    :tokenizer => lambda { |str| str.scan(/\s+|$/) },
    :too_long  => "must have at most %{count} words"
  }

  validates :title, :presence => true, length: { maximum: 100 }

  def self.by_year(year)
    where('extract(year from created_at) = ?', year)
  end

  def self.by_month(month)
    where('extract(month from created_at) = ?', month)
  end

  def self.by_day(day)
    where('extract(day from created_at) = ?', day)
  end

end
