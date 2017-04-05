class ConferenceAttendee < ApplicationRecord
  belongs_to :conference
  belongs_to :user
end
