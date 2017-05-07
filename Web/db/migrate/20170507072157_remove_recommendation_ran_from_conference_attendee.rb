class RemoveRecommendationRanFromConferenceAttendee < ActiveRecord::Migration[5.0]
  def change
    remove_column :conference_attendees, :recommendation_ran, :boolean
  end
end
