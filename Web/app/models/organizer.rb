class Organizer < ApplicationRecord
  belongs_to :user
  has_many :conference_organizers
  has_many :conferences, through: :conference_organizers
end
