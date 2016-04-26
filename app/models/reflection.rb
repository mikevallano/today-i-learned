class Reflection < ActiveRecord::Base
  belongs_to :user

  validates :body, :presence => true,
  :length => {
    :maximum   => 300,
    :tokenizer => lambda { |str| str.scan(/\s+|$/) },
    :too_long  => "must have at most %{count} words"
  }

  validates :title, :presence => true, length: { maximum: 100 }

end
