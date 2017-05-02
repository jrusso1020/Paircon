require 'base64'
require 'scrapper/pdf_scrapper'
require 'fileutils'
class UsersController < ApplicationController
  before_action :check_session, :only => [:show]
  before_action :authenticate_user!, except: [:validation]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def check_session
    redirect_to root_path unless current_user
  end

  def approved_organizers
    @user = current_user
    @approved_organizers = User.joins(:organizer).select(:id, :first_name, :last_name, :email, :user_industry, :user_organization, 'organizers.updated_at').where(organizers: {approved: false})
  end

  def pending_organizers
    @user = current_user
    @pending_organizers = User.includes(:organizer).where(organizers: {approved: false})
    @approved_organizers = User.joins(:organizer).select(:id, :first_name, :last_name, :email, :user_organization, :user_industry, 'organizers.updated_at').where(organizers: {approved: false})
  end

  def approve_organizer
    tran_success = false
    user = User.find(params[:id])
    Organizer.transaction do
      tran_success = user.update!(user_type: User.user_types[:organizer])
      tran_success = tran_success and (Organizer.find_by_user_id(params[:id]).update!(approved: true)) 

      unless tran_success
        raise ActiveRecord::Rollback
      end
    end

    if tran_success
      render status: :ok, text: "You Have Approved #{user.full_name} As An Organizer."
    else
      render status: :internal_server_error, text: "There was some problem while trying to approving #{user.full_name}. Please try again later ..."
    end
  end

  # request organizer privilege
  def request_organizer
    @user = current_user
    @organizer = Organizer.create!(user_id: @user.id)

    if @organizer
      flash[:notice] = 'Your Have Requested Organizer Access, Please Wait For Your Request To Be Processed.'
    else
      flash[:error] = 'There was some error while trying to process your request. Please try again later.'
    end

    redirect_back(fallback_location: :back)
  end

  def become_organizer
    @user = current_user
  end

  def show
  end

  def edit
    render layout: 'sign_up' if params[:referer] == REFERERS[:app_init] && !current_user.is_app_init
  end

  def refresh_profile
    @user = current_user
    if not @user.url.blank?
      @user.scrape_profile
    end
  end

  def update
    respond_to do |format|

      scrape_profile = false
      if params[:referer] == REFERERS[:app_init]
        init_app_after_first_sign_up
        save_logo
        if(not @user.url.blank?)
          scrape_profile = true
        end
      end

      if @user.is_app_init and (not user_params[:url].blank?) and (user_params[:url] != @user.url)
        scrape_profile = true
      end

      if @user.update_attributes(user_params)
        if scrape_profile
          @user.scrape_profile
        end
        if params[:referer] == REFERERS[:app_init]
          unless Identity.find_by_user_id(@user.id).nil?
            sign_in @user, :bypass => true
          end
          format.html { redirect_to dashboard_path(), notice: "Hi #{@user.full_name.capitalize}! Welcome to PairCon ... Look at upcoming research conferences and get personalized recommendations today!" }
        else
          # @user.activity(:update)
          format.html { redirect_to @user, notice: 'Your personal information has been updated successfully.' }
          format.json { render :show, status: :ok, location: @user }
        end
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete_account
    # Need to verify current password and delete the user and logout from the current session
    @user = current_user
    if verify_recaptcha
      if @user.valid_password?(params[:user][:current_password])
        @user.destroy
        sign_out @user
        flash[:notice] = 'Your account has been successfully deleted from PairCon.'
        redirect_to new_user_session_url() and return
      else
        flash[:error] = 'Your current password appears to be incorrect. Please try again later ...'
        respond_to do |format|
          format.html { redirect_to user_path(User.find(params[:id])) }
        end
      end
    else
      flash[:error] = 'The Captcha entered appears to be incorrect. Please try again later ...'
      respond_to do |format|
        format.html { redirect_to user_path(User.find(params[:id])) }
      end
    end

  end

  def delete
    @user = current_user
  end

  def save_logo
    unless params[:name].blank?
      FileUtils.mkdir_p "#{Rails.root}/tmp/logo"
      new_file = "#{Rails.root}/tmp/logo/#{params[:name]}"

      File.open(new_file, 'wb') do |file|
        file.write(Base64.decode64 params[:data].split(",")[1])
      end

      current_user.logo = File.open(new_file, 'r')
      current_user.save!(validate: false)
      # current_user.activity(:update)

      File.delete(new_file)
    end

    render json: {status: 'success', url: current_user.profile_photo, filename: current_user.logo_file_name} if params[:referer] != REFERERS[:app_init]
  end

  def destroy
    @user.destroy
  end

  def destroy_logo
    current_user.logo = nil unless current_user.logo.nil?
    current_user.save!(validate: false)
    render json: {status: 'success'}
  end

  def password_reset
    @user = current_user
  end

  def update_email_password

    @user = current_user

    if verify_recaptcha
      if @user.update_with_password(user_params)
        sign_in(@user, :bypass => true)

        if params[:user][:password].blank?
          flash[:notice] = 'Email Address has been updated succesfully.'
        else
          flash[:notice] = 'Password has been updated succesfully. '
        end

        redirect_to :back
      else
        flash[:error] = 'Your current password appears to be incorrect. Please try again later ...'
        respond_to do |format|
          format.html { redirect_to user_path(User.find(params[:id])) }
        end
      end
    else
      flash[:error] = 'The Captcha entered appears to be incorrect. Please try again later ...'
      respond_to do |format|
        format.html { redirect_to user_path(User.find(params[:id])) }
      end
    end
  end

  def timezone
    @user = current_user
  end

  def validation
    if !params[:is_login].blank?
      render plain: current_user.nil? ? 'false' : 'true'
    elsif !params[:user][:username].blank?
      render plain: User.where(username: params[:user][:username]).first.nil? ? 'true' : 'false'
    elsif !params[:user][:email].blank?
      render plain: User.where(email: params[:user][:email]).first.nil? ? 'true' : 'false'
    else
      render plain: 'false'
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit!
  end

  def init_app_after_first_sign_up
    @user.is_app_init = true
    @user.last_messages_read = (Time.now - 1.week)
    @user.last_notifications_read = (Time.now - 1.week)

    # Notifier.startup_instructions(current_user).deliver_later
    @user.activity(:create)
  end

end
