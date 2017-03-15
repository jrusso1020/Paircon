# == Schema Information
#
# Table name: conference_papers
#
# *id*::            <tt>integer, not null, primary key</tt>
# *paper_id*::      <tt>integer</tt>
# *conference_id*:: <tt>integer</tt>
# *created_at*::    <tt>datetime, not null</tt>
# *updated_at*::    <tt>datetime, not null</tt>
#--
# == Schema Information End
#++

class ConferencePaper < ApplicationRecord
  has_many :conferences, :papers
end
