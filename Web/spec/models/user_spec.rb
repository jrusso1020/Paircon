require "rails_helper"

describe User do
  fixtures :all

  let(:user) { users(:kilian) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to have_many(:conference_attendees) }
  it { is_expected.to have_many(:conference_organizers) }
  it { is_expected.to have_one(:organizer) }
  it { is_expected.to have_many(:identities) }
  it { is_expected.to have_many(:user_papers) }
  it { is_expected.to have_many(:papers).through(:user_papers) }
  it { is_expected.to define_enum_for(:user_type) }

  describe "#full_name=" do
    it "sets the first_name and last_name" do
      user = User.new(full_name: "Kilian Weinberger")

      expect(user.first_name).to eq("Kilian")
      expect(user.last_name).to eq("Weinberger")
    end
  end

  describe "#full_name" do
    it "joins the first and last name with a space" do
      expect(users(:kilian).full_name).to eq "Kilian Weinberger"
    end
  end

  describe "#profile_photo" do
    it "returns the profile photo" do
      expect(users(:kilian).profile_photo).to eq "Male.jpg"
    end
  end
end