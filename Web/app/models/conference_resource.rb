# == Schema Information
#
# Table name: conference_resources
#
#  conference_resource_id :string(30)       not null, primary key
#  conference_id          :string(30)
#  room                   :string
#  title                  :string
#  eventColor             :string
#  parent_id              :string(30)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_conference_resources_on_conference_id           (conference_id)
#  index_conference_resources_on_conference_resource_id  (conference_resource_id) UNIQUE
#  index_conference_resources_on_parent_id               (parent_id)
#
class ConferenceResource < ApplicationRecord
  belongs_to :conference
  has_many :conference_events
  before_create :init_id

  # Map for Types of Conference Resources
  TYPE = {
      event: 'event',
      session: 'session'
  }

  self.primary_key = :conference_resource_id

  private

  # Create Conference Resource id
  def init_id
    self.id = CodeGenerator.code(ConferenceResource.new, ConferenceResource.primary_key.to_s, 30)
  end

end
