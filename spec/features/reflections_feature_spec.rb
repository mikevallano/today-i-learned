require "rails_helper"

RSpec.feature "Reflections feature spec", :type => :feature do

  feature "Users create, edit, update, view, and destroy reflections" do
    let(:user) { FactoryGirl.create(:user, time_zone: 'Central Time (US & Canada)') }
    let(:reflection) { FactoryGirl.create(:reflection, user: user) }
    let(:reflection_1_day_ago) { FactoryGirl.create(:reflection, created_at: 1.day.ago, user: user) }
    let(:reflection_2_days_ago) { FactoryGirl.create(:reflection, created_at: 2.days.ago, user: user) }
    let(:reflection_3_days_ago) { FactoryGirl.create(:reflection, created_at: 3.days.ago, user: user) }
    let(:reflection_5_days_ago) { FactoryGirl.create(:reflection, created_at: 5.days.ago, user: user) }
    let(:reflection_today_utc) { FactoryGirl.create(:reflection, created_at: Time.current.at_beginning_of_day, user: user) }
    let(:reflection_yesterday_utc) { FactoryGirl.create(:reflection, created_at: (Time.current.at_beginning_of_day - 1.day), user: user) }

    before(:each) do
      sign_in_user(user)
    end

    scenario "user can create a new reflection" do
      visit root_path
      click_link "reflections_index_nav_link"
      click_link "new_reflection_link_reflections_index"

      fill_in "reflection_title", with: reflection.title
      fill_in "reflection_body", with: reflection.body
      click_button "reflection_submit_button"

      expect(current_url).to eq(reflection_url(Reflection.last))
    end

    scenario "time_zone is defualt to UTC" do
      reflection_today_utc

      expect(reflection_today_utc.created_at.to_date).to eq(Time.current.at_beginning_of_day.in_time_zone("UTC").to_date)
    end

    scenario "time_zone is converted to user's time zone" do
      reflection_today_utc

      expect(reflection_today_utc.created_at.to_date).not_to eql(Time.current.at_beginning_of_day.in_time_zone(user.time_zone).to_date)
    end

    scenario "reflected_today is calculated from user's time zone" do
      reflection_today_utc
      visit root_path

      #the homepage checks if the user has reflected 'today', which is relative to the user.
      #reflection_today_utc was created in UTC, but the user's time_zone is 4 hours earlier, and therefore yesterday
      expect(page).to have_content("Your last reflection was entered on #{user.last_reflection_date}")
    end

    scenario "current_streak is calculated from user's time zone" do
      reflection_yesterday_utc
      visit root_path

      #current_streak checks if the user's last reflection was a day ago.
      #reflection_yesterday_utc was yesterday in UTC, but the user's time zone is 4 hours earlier, therefore
      #the user has not reflected within the past day, and the streak should be zero.
      expect(page).to have_content("0 days")
    end

    scenario "shows current streak up to missing day" do
      all_reflections
      visit root_path

      expect(page).to have_content("4 days")
    end

    scenario "shows streak of zero if a reflection has not been created in the last day" do
      reflection_2_days_ago
      reflection_3_days_ago

      visit root_path
      expect(page).to have_content("0 days")
    end

    scenario "shows streak of 1 day if last reflection was yesterday" do
      reflection_1_day_ago

      visit root_path
      expect(page).to have_content("1 day")
    end

  end #feature "Users create, edit, update, view, and destroy reflections" do

end #final