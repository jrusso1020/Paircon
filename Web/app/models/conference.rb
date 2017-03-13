class Conference < ApplicationRecord
  belongs_to :conference_attendee, :conference_paper
end
