# Notifier To Handle sending emails
class Notifier < ActionMailer::Base
  include Devise::Mailers::Helpers

  default from: 'Paircon <no-reply@paircon.com>'

  # Action used to send Conference Invite To Users
  # @return [HTML] Renders and Sends Conference Invite Email
  def conference_invite(conference, full_name, email, custom_message)
    @conference = conference
    @custom_message = custom_message
    @email = email
    attachments.inline['logo.jpg'] = File.read(conference.logo_path)

    mail(
        :to => email,
        :subject => "#{full_name} has invited you to #{conference.get_name}"
    )
  end
end