# == Schema Information
#
# Table name: conference_organizers
#
#  id            :string(30)       not null, primary key
#  conference_id :string(30)
#  user_id       :string(30)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_conference_organizers_on_user_id_and_conference_id  (user_id,conference_id) UNIQUE
#

# Model responsible for ConferenceOrganizer objects
class ConferenceOrganizer < ApplicationRecord
  alias_attribute :organizers, :users
  belongs_to :conference
  belongs_to :user

  before_create :init_id

  private

  # Create a Conference Organizer id
  def init_id
    self.id = CodeGenerator.code(ConferenceOrganizer.new, 'id', 30)
  end

end

