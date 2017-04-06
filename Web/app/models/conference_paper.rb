# == Schema Information
#
# Table name: conference_papers
#
# *id*::            <tt>integer, not null, primary key</tt>
# *paper_id*::      <tt>string(30)</tt>
# *conference_id*:: <tt>string(30)</tt>
# *created_at*::    <tt>datetime, not null</tt>
# *updated_at*::    <tt>datetime, not null</tt>
#--
# == Schema Information End
#++

class ConferencePaper < ApplicationRecord
  belongs_to :conference
  belongs_to :paper
end
