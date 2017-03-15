# == Schema Information
#
# Table name: conferences
#
# *id*::         <tt>integer, not null, primary key</tt>
# *name*::       <tt>string</tt>
# *start_date*:: <tt>datetime</tt>
# *end_date*::   <tt>datetime</tt>
# *url*::        <tt>text</tt>
# *location*::   <tt>string</tt>
# *pending*::    <tt>boolean</tt>
# *created_at*:: <tt>datetime, not null</tt>
# *updated_at*:: <tt>datetime, not null</tt>
#--
# == Schema Information End
#++

class Conference < ApplicationRecord
  belongs_to :conference_attendee
  belongs_to :conference_paper
end