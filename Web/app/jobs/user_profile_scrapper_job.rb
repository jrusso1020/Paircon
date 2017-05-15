require 'users/user_utils'

class UserProfileScrapperJob < ApplicationJob
  queue_as :default

  # User profile scrapper job perform function that is called whenever this job is enqueued as a background job
  # Calls the scrapeUserProfile function of UserUtils
  # Downloads all the pdfs from the user profile, run pdf to txt conversion on the pdfs and stores the text files
  # @params user [User] user object for which the profile profile is to be scraped
  def perform(user)
    UserUtils.new(user).scrapeUserProfile()
  end
end
