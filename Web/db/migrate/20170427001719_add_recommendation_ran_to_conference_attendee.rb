class AddRecommendationRanToConferenceAttendee < ActiveRecord::Migration[5.0]
  def change
    add_column :conference_attendees, :recommendation_ran, :boolean, :default => false
  end
end
