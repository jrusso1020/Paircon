require "rails_helper"

describe Similarity, type: :model do
  it { is_expected.to have_one(:paper_user) }
  it { is_expected.to have_one(:paper_conference) }
end
