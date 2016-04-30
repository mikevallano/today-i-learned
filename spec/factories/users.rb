FactoryGirl.define do
  factory :user, :aliases => [:member, :owner] do
    email { FFaker::Internet.email }
    sequence(:username) { |n| "user_name#{n}" }
    time_zone 'Central Time (US & Canada)'
    password 'password'
    password_confirmation 'password'
    confirmed_at Time.current

    factory :invalid_user do
      email nil
    end
  end

end