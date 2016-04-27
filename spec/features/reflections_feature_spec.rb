require "rails_helper"

RSpec.feature "Reflections feature spec", :type => :feature do

  feature "Users create, edit, update, view, and destroy reflections" do
    let(:user) { FactoryGirl.create(:user) }
    let(:reflection) { FactoryGirl.create(:reflection) }

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

  end #feature "Users create, edit, update, view, and destroy reflections" do

end #final