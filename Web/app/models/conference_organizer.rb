class ConferenceOrganizer < ApplicationRecord
  alias_attribute :organizers, :users
  has_many :conferences, :users
end
