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

  # request organizer privilege
  def request_organizer
    @user = current_user
    @organizer = Organizer.create(user_id: @user.id)
  end

  def become_organizer
    @user = current_user
  end

  def show
  end

  # This function will be removed at a later stage and update command will be used
  def submit_url
    if !params[:user][:url].blank?
      pdf_folder = current_user.get_pdf_folder_path
      FileUtils::mkdir_p pdf_folder
      txt_folder = current_user.get_pdf_text_path
      FileUtils::mkdir_p txt_folder
      q = params[:user][:url]
      current_user.url = q
      current_user.save!(validate: false)
      scrapper = PDFScrapper.new(q, PDFScrapper::PageType[:personal])
      scrapper.downloadAllPdfs(pdf_folder)
      scrapper.convertPdfToText(pdf_folder, txt_folder)

      flash[:notice] = 'Your personal URL has been updated successfully'
    end

    redirect_back(fallback_location: :back)
  end

  def edit
    render layout: 'sign_up' if params[:referer] == REFERERS[:app_init] && !current_user.is_app_init
  end

  def update
    respond_to do |format|

      if params[:referer] == REFERERS[:app_init]
        init_app_after_first_sign_up
        save_logo
      end

      if @user.update_attributes(user_params)
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
      new_file = "#{Rails.root}/public/logo/#{params[:name]}"

      File.open(new_file, 'wb') do |file|
        file.write(Base64.decode64 params[:data].split(",")[1])
      end

      current_user.logo = File.open(new_file, 'r')
      current_user.save!(validate: false)
      # current_user.activity(:update)

      File.delete(new_file)
    end

    render text: '1' if params[:referer] != REFERERS[:app_init]
  end

  def destroy
    @user.destroy
  end

  def destroy_logo
    current_user.logo = nil unless current_user.logo.nil?
    current_user.save!(validate: false)
    render text: '1'
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
      render text: current_user.nil? ? 'false' : 'true'
    elsif !params[:user][:username].blank?
      render text: User.where(username: params[:user][:username]).first.nil? ? 'true' : 'false'
    elsif !params[:user][:email].blank?
      render text: User.where(email: params[:user][:email]).first.nil? ? 'true' : 'false'
    else
      render text: 'false'
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
    # @user.activity(:create)
  end

end