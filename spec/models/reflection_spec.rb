require 'rails_helper'

RSpec.describe Reflection, type: :model do

  let(:reflection) { FactoryGirl.create(:reflection) }
  let(:reflection_too_long_title) { FactoryGirl.build(:reflection_too_long_title) }
  let(:reflection_too_long_body) { FactoryGirl.build(:reflection_too_long_body) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to belong_to(:user) }

  context "with a valid factory" do

    it "is valid" do
      expect(reflection).to be_valid
    end

    it "has a title" do
      expect(reflection).to respond_to(:title)
    end

    it "has a body" do
      expect(reflection).to respond_to(:body)
    end

    it "has a user" do
      expect(reflection.user).not_to be nil
    end

  end #valid factory context

  context "with an invalid factory" do

    it "is invalid if the title is too long" do
      expect(reflection_too_long_title).not_to be_valid
    end

    it "is invalid if the body is too long" do
      expect(reflection_too_long_body).not_to be_valid
    end

  end #invalid factory context

end
