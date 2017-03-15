class ConferenceAttendee < ApplicationRecord
  alias_attribute :attendees, :users
  has_many :conferences, :users
end
