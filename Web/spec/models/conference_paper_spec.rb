require "rails_helper"

describe ConferencePaper, type: :model do
  it { is_expected.to belong_to(:conference) }
  it { is_expected.to belong_to(:paper) }
  it { is_expected.to have_many(:similarities) }
end
