require 'scrapper/pdf_scrapper'
class PapersController < ApplicationController
  before_action :find_paper, only: [:edit, :update, :show, :delete]
  before_action :authenticate_user!, except: [:validation]
  before_action :check_session, :only => [:show]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def set_user
    @user = current_user
  end

  def check_session
    redirect_to root_path unless current_user
  end

  # Index action to render all conferences
  def index
  end

  # New action for creating conference
  def new
    @paper = Paper.new
  end

  # Create action saves the conference into database
  def create
    @paper = Paper.new(paper_params)
    if @paper.save
      @conferencePaper = ConferencePaper.new(:conference_id => params[:conference_id], :paper_id => @paper.id)
      if @conferencePaper.save
        flash[:notice] = "Successfully created paper!"
        redirect_to conference_path(Conference.find(params[:conference_id]))
      else
        flash[:alert] = "Error creating new paper!"
        render :new
      end
    else
      flash[:alert] = "Error creating new paper!"
      render :new
    end

  end

  # Edit action retrives the conference and renders the edit page
  def edit
  end

  # Update action updates the conference with the new information
  def update
    if @paper.update_attributes(paper_params)
      flash[:notice] = "Successfully updated paper!"
      redirect_to conference_path(Conference.find(params[:conference_id]))
    else
      flash[:alert] = "Error updating paper!"
      render :edit
    end
  end

  # The show action renders the individual conference after retrieving the the id
  def show
  end

  # The destroy action removes the conference permanently from the database
  def destroy
    if @paper.destroy and @conferencePaper.destroy
      flash[:notice] = "Successfully deleted paper!"
      redirect_to conference_path
    else
      flash[:alert] = "Error updating paper!"
    end
  end

  private

  def paper_params
    uploaded_io = params[:paper][:file]
    pdf_path = Rails.root.join('public', 'conference', params[:conference_id], 'pdf', uploaded_io.original_filename)
    pdf_folder = Rails.root.join('public', 'conference', params[:conference_id], 'pdf')
    FileUtils::mkdir_p pdf_folder
    File.open(pdf_path, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    scrapper = PDFScrapper.new("dummy", PDFScrapper::PageType[:personal])
    txt_file = Rails.root.join('public', 'conference', params[:conference_id], 'txt', File.basename(uploaded_io.original_filename, File.extname(uploaded_io.original_filename)) + ".txt")
    txt_folder = Rails.root.join('public', 'conference', params[:conference_id], 'txt')
    FileUtils::mkdir_p txt_folder
    scrapper.convertSinglePdfToText(pdf_path, txt_folder)

    paper_params = {
        "title" => params[:paper][:title],
        "path" => txt_file,
        "pdf_link" => pdf_path
    }
    paper_params
  end

  def find_paper
    @paper = Paper.find(params[:id])
  end
end
