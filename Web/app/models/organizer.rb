# == Schema Information
#
# Table name: organizers
#
#  organizer_id :string(30)       not null, primary key
#  user_id      :string(30)
#  approved     :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_organizers_on_organizer_id  (organizer_id) UNIQUE
#  index_organizers_on_user_id       (user_id) UNIQUE
#
class Organizer < ApplicationRecord
  belongs_to :user
  has_many :conference_organizers, foreign_key: :user_id
  has_many :conferences, through: :conference_organizers

  before_create :init_id

  self.primary_key = :organizer_id

  private

  # Create organizer id
  def init_id
    self.id = CodeGenerator.code(Organizer.new, self.Organizer.to_s, 30)
  end

end
