# == Schema Information
#
# Table name: organizers
#
# *id*::         <tt>integer, not null, primary key</tt>
# *user_id*::    <tt>string</tt>
# *pending*::    <tt>boolean, default("false")</tt>
# *created_at*:: <tt>datetime, not null</tt>
# *updated_at*:: <tt>datetime, not null</tt>
#--
# == Schema Information End
#++

class Organizer < ApplicationRecord
  has_many :users
end
