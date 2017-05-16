require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :all

  it { is_expected.to have_many(:conference_attendees) }
  it { is_expected.to have_many(:conference_organizers) }
  it { is_expected.to have_many(:user_papers) }
  it { is_expected.to have_one(:organizer) }
  it { is_expected.to have_many(:identities) }
  it { is_expected.to have_many(:conferences) }
  it { is_expected.to have_many(:conferences) }
  it { is_expected.to have_many(:papers) }
end