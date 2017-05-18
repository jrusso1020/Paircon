require "rails_helper"

describe ConferenceAttendee, type: :model do
  it { is_expected.to belong_to(:conference) }
  it { is_expected.to belong_to(:user) }
end
