# Job for scraping pdfs from user profile link and then converting them to text files
class UserProfileScrapperJob < ApplicationJob
  require 'users/user_utils'
  queue_as :default

  # This function is called whenever this job is enqueued as a background job.
  # Calls the scrapeUserProfile function of UserUtils.
  # Downloads all the pdfs from the user profile, run pdf to txt conversion on the pdfs and stores the text files.
  # @param user [User] user object for which the profile profile is to be scraped
  def perform(user)
    UserUtils.new(user).scrapeUserProfile()
  end
end
