class ConferenceAttendee < ApplicationRecord
  has_many :users, :conferences
end
