require "rails_helper"

describe Notification, type: :model do
  fixtures :all

  let(:user) { user(:kilian) }

  it { is_expected.to belong_to(:creator) }

  describe ".find_all_notifications" do
    it "returns all notifications for a given user" do
      expect(Notification.find_all_notifications(users(:kilian)).size).to eq 0
    end
  end

  describe ".find_new_notifications" do
    it "returns all new notifications for a given user" do
      expect(Notification.find_new_notifications(Notification.find_all_notifications(users(:kilian)), users(:kilian))).to eq 0
    end
  end
end
