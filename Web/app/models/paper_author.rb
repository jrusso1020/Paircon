# == Schema Information
#
# Table name: paper_authors
#
# *id*::         <tt>integer, not null, primary key</tt>
# *paper_id*::   <tt>string(30)</tt>
# *user_id*::    <tt>string(30)</tt>
# *created_at*:: <tt>datetime, not null</tt>
# *updated_at*:: <tt>datetime, not null</tt>
#--
# == Schema Information End
#++

class PaperAuthor < ApplicationRecord
  alias_attribute :authors, :users
  belongs_to :paper
  belongs_to :user
end
