# == Schema Information
#
# Table name: organizers
#
#  id         :string(30)       not null, primary key
#  user_id    :string
#  approved   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_organizers_on_user_id  (user_id) UNIQUE
#

class Organizer < ApplicationRecord
  belongs_to :user
  has_many :conference_organizers
  has_many :conferences, through: :conference_organizers

  before_create :init_id

  private

  def init_id
    self.id = CodeGenerator.code(Organizer.new, 'id', 30)
  end

end
