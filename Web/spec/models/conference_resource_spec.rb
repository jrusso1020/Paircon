require "rails_helper"

describe ConferenceResource, type: :model do
  it { is_expected.to belong_to(:conference) }
  it { is_expected.to have_many(:conference_events) }
end
