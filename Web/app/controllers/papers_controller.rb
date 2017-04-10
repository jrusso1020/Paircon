require 'scrapper/pdf_scrapper'
class PapersController < ApplicationController
  include ConferencesHelper
  before_action :authenticate_user!, except: [:validation]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def new
    @title = 'Add Paper'
    @body = 'Please enter the paper title and file upload path'
    render layout: false
  end

  def set_user
    @user = current_user
  end


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

  def create
    @paper = Paper.new(paper_params)
    if @paper.save
      @conferencePaper = ConferencePaper.new(:conference_id => params[:conference_id], :paper_id => @paper.id)
      if @conferencePaper.save
        flash[:notice] = "Successfully created paper!"
      else
        flash[:alert] = "Error creating new paper!"
      end
    else
      flash[:alert] = "Error creating new paper!"
    end
    redirect_back(fallback_location: root_path)
  end

  def delete
    render layout: false
  end

  # The destroy action removes the conference permanently from the database
  def destroy
    Paper.transaction do
      if @paper.destroy and @conferencePaper.destroy
        flash[:notice] = 'Paper has been successfully deleted.'
      else
        flash[:error] = 'Unable to delete Paper due to some error. Please try again later ...'
      end
    end
    redirect_back(fallback_location: root_path)
  end

end
