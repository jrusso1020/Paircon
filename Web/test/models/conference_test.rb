# == Schema Information
#
# Table name: conferences
#
# *id*::                 <tt>string(30), not null, primary key</tt>
# *name*::               <tt>string</tt>
# *start_date*::         <tt>datetime</tt>
# *end_date*::           <tt>datetime</tt>
# *url*::                <tt>text</tt>
# *location*::           <tt>string</tt>
# *created_at*::         <tt>datetime, not null</tt>
# *updated_at*::         <tt>datetime, not null</tt>
# *logo_file_name*::     <tt>string</tt>
# *logo_content_type*::  <tt>string</tt>
# *logo_file_size*::     <tt>integer</tt>
# *logo_updated_at*::    <tt>datetime</tt>
# *cover_file_name*::    <tt>string</tt>
# *cover_content_type*:: <tt>string</tt>
# *cover_file_size*::    <tt>integer</tt>
# *cover_updated_at*::   <tt>datetime</tt>
# *description*::        <tt>string(255), default("")</tt>
# *domain*::             <tt>string(255), default("")</tt>
# *publish*::            <tt>boolean, default(FALSE)</tt>
# *archive*::            <tt>boolean, default(FALSE)</tt>
# *phone*::              <tt>string(255), default("")</tt>
# *email*::              <tt>string(255), default("")</tt>
#--
# == Schema Information End
#++

require 'test_helper'

class ConferenceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
