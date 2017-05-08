require 'users/user_utils'

class UserProfileScrapperJob < ApplicationJob
  queue_as :default

  def perform(user)
    UserUtils.new(user).scrapeUserProfile()
  end
end
