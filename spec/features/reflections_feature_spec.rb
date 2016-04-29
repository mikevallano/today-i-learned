require "rails_helper"

RSpec.feature "Reflections feature spec", :type => :feature do

  feature "Users create, edit, update, view, and destroy reflections" do
    let(:user) { FactoryGirl.create(:user) }
    let(:reflection) { FactoryGirl.create(:reflection, user: user) }
    let(:reflection_1_day_ago) { FactoryGirl.create(:reflection, created_at: 1.day.ago, user: user) }
    let(:reflection_2_days_ago) { FactoryGirl.create(:reflection, created_at: 2.days.ago, user: user) }
    let(:reflection_3_days_ago) { FactoryGirl.create(:reflection, created_at: 3.days.ago, user: user) }
    let(:reflection_5_days_ago) { FactoryGirl.create(:reflection, created_at: 5.days.ago, user: user) }

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