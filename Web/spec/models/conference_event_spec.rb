require "rails_helper"

describe ConferenceEvent, type: :model do
  it { is_expected.to belong_to(:conference) }
  it { is_expected.to belong_to(:conference_resource) }
  it { is_expected.to define_enum_for(:event_type) }
end
