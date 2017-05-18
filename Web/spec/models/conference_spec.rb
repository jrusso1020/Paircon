require "rails_helper"

describe Conference, type: :model do
  fixtures :all

  let(:conference) { conferences(:aaai) }

  it { is_expected.to have_many(:notification) }
  it { is_expected.to have_many(:conference_attendees) }
  it { is_expected.to have_many(:conference_resources) }
  it { is_expected.to have_many(:conference_events) }
  it { is_expected.to have_many(:conference_papers) }
  it { is_expected.to have_many(:conference_organizers) }
  it { is_expected.to have_many(:posts) }
  it { is_expected.to have_many(:organizers).through(:conference_organizers) }
  it { is_expected.to have_many(:papers).through(:conference_papers) }
  it { is_expected.to have_many(:users).through(:conference_attendees) }

  describe "#logo_picture" do
    it "returns the conference logo picture" do
      expect(conferences(:aaai).logo_picture).to eq "Paircon_logo.png"
    end
  end

  describe "#logo_path" do
    it "returns the conference logo picture" do
      expect(conferences(:aaai).logo_path).to eq Rails.root.join('app/assets/images/Paircon_logo.png')
    end
  end

  describe "#cover_photo" do
    it "returns the conference cover photo" do
      expect(conferences(:aaai).cover_photo).to eq nil
    end
  end

  describe "#get_name" do
    it "returns the name of the conference" do
      expect(conferences(:aaai).get_name).to eq "AAAI"
    end
  end

  describe "#get_counts" do
    it "returns the counts of posts, interested, resources, events" do
      expect(conferences(:aaai).get_counts.size).to eq 4
      expect(conferences(:aaai).get_counts).to eq [0,0,0,0]
    end
  end

  describe "#is_organizer" do
    it "returns whether a user is an organizer" do
      expect(conferences(:aaai).is_organizer(users(:kilian))).to eq false
    end
  end

  describe ".my_organizing_conferences" do
    it "returns all conferences a user organizers" do
      expect(Conference.my_organizing_conferences(users(:kilian)).size).to eq 0
    end
  end

  describe ".my_attending_conferences" do
    it "returns all conferences a user attends" do
      expect(Conference.my_attending_conferences(users(:kilian)).size).to eq 0
    end
  end

  describe "#get_conference_path" do
    it "returns the path to the conferences folder" do
      expect(conferences(:aaai).get_conference_path).to eq "#{Rails.root}/public/conferences/#{conferences(:aaai).id}"
    end
  end

  describe "#get_pdf_text_path" do
    it "returns the path to the conferences text document folder" do
      expect(conferences(:aaai).get_pdf_text_path).to eq "#{Rails.root}/public/conferences/#{conferences(:aaai).id}/txt"
    end
  end

  describe "#get_pdf_folder_path" do
    it "returns the path to the conferences pdf document folder" do
      expect(conferences(:aaai).get_pdf_folder_path).to eq "#{Rails.root}/public/conferences/#{conferences(:aaai).id}/pdf"
    end
  end
end
