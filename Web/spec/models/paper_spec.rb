require "rails_helper"

describe Paper, type: :model do
  it { is_expected.to have_one(:conference_paper) }
  it { is_expected.to have_one(:user_paper) }
end
