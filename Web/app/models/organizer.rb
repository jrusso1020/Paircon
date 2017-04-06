# == Schema Information
#
# Table name: organizers
#
# *id*::         <tt>string(30), not null, primary key</tt>
# *user_id*::    <tt>string</tt>
# *approved*::   <tt>boolean, default(FALSE)</tt>
# *created_at*:: <tt>datetime, not null</tt>
# *updated_at*:: <tt>datetime, not null</tt>
#--
# == Schema Information End
#++

class Organizer < ApplicationRecord
  belongs_to :user
  has_many :conference_organizers
  has_many :conferences, through: :conference_organizers
end
