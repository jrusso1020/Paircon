class UserProfileScrapperJob < ApplicationJob
  queue_as :default

  include UserHelper
  def perform(user)
    scrapeUserProfile(user)
  end
end
