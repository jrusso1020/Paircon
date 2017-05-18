require "rails_helper"

describe Organizer, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:conference_organizers) }
  it { is_expected.to have_many(:conferences).through(:conference_organizers) }
end
