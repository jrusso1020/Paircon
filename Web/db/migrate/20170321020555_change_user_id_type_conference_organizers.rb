class ChangeUserIdTypeConferenceOrganizers < ActiveRecord::Migration[5.0]
  def change
    change_column(:conference_organizers, :user_id, :string)
  end
end
