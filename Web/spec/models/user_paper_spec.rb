require "rails_helper"

describe UserPaper, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:paper) }
  it { is_expected.to have_many(:similarities) }
end
