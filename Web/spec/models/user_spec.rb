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

  describe "#profile_photo_full_link" do
    it "returns the full path of the profile photo" do
      expect(users(:kilian).profile_photo_full_link).to eq "#{PairConConfig::root_domain + ActionController::Base.helpers.asset_path(users(:kilian).profile_photo)}"
    end
  end

  describe "#get_pdf_text_path" do
    it "returns the full path of the user's text folder" do
      expect(users(:kilian).get_pdf_text_path).to eq "#{Rails.root}/public/users/#{users(:kilian).id}/txt"
    end
  end

  describe "#get_pdf_folder_path" do
    it "returns the full path of the user's pdf folder" do 
      expect(users(:kilian).get_pdf_folder_path).to eq "#{Rails.root}/public/users/#{users(:kilian).id}/pdfs"
    end
  end

  describe "#pending_organizer" do
    it "returns whether or not the user is in the pending organizer table" do 
      expect(users(:kilian).pending_organizer).to eq false
    end
  end

  describe "#is_attending" do
    it "returns whether or not the user is attending the given conference" do
      expect(users(:kilian).is_attending(conferences(:aaai).id)).to eq false
    end
  end

  describe "#all_similarities_generated" do
    it "returns whether or not the user has had all their similarities generated for a given conference" do
      expect(users(:kilian).all_similarities_generated(conferences(:aaai).id)).to eq true
    end
  end
end