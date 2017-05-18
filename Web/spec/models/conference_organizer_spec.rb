require "rails_helper"

describe ConferenceOrganizer, type: :model do
  it { is_expected.to belong_to(:conference) }
  it { is_expected.to belong_to(:user) }
end
