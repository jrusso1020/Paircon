# == Schema Information
#
# Table name: users
#
# *id*::                      <tt>string(30), not null, primary key</tt>
# *email*::                   <tt>string, default(""), not null</tt>
# *encrypted_password*::      <tt>string, default(""), not null</tt>
# *reset_password_token*::    <tt>string</tt>
# *reset_password_sent_at*::  <tt>datetime</tt>
# *remember_created_at*::     <tt>datetime</tt>
# *sign_in_count*::           <tt>integer, default("0"), not null</tt>
# *current_sign_in_at*::      <tt>datetime</tt>
# *last_sign_in_at*::         <tt>datetime</tt>
# *current_sign_in_ip*::      <tt>string</tt>
# *last_sign_in_ip*::         <tt>string</tt>
# *confirmation_token*::      <tt>string</tt>
# *confirmed_at*::            <tt>datetime</tt>
# *confirmation_sent_at*::    <tt>datetime</tt>
# *unconfirmed_email*::       <tt>string</tt>
# *created_at*::              <tt>datetime, not null</tt>
# *updated_at*::              <tt>datetime, not null</tt>
# *first_name*::              <tt>string(20)</tt>
# *last_name*::               <tt>string(20)</tt>
# *default_lang*::            <tt>string, default("en")</tt>
# *is_deleted*::              <tt>boolean, default("false")</tt>
# *is_active*::               <tt>boolean, default("false")</tt>
# *is_app_init*::             <tt>boolean, default("false")</tt>
# *time_zone_name*::          <tt>string</tt>
# *last_messages_read*::      <tt>datetime</tt>
# *last_notifications_read*:: <tt>datetime</tt>
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#--
# == Schema Information End
#++

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end