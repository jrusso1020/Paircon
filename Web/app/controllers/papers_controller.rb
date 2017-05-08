# Controller primarily responsible for handling Papers
class PapersController < ApplicationController
  require 'scrapper/pdf_scrapper'
  require 'papers/paper_utils'

  before_action :authenticate_user!, except: [:validation]
  before_action :find_paper, except: [:index, :new, :create]

  # Action used for showing modal for new paper
  def new
    @title = 'Add Paper / Poster'
    @body = 'Please enter information about the Paper, optional details about the author(s) and upload a PDF version of the Paper.'
    render layout: false
  end

  # Action used to process creation of paper
  def create
    parameters = JSON(params[:json], symbolize_names: true)

    if Paper::PAPER_MIME_TYPES.include?(params[:fileData].content_type)
      conference = Conference.find(parameters[:conference_id])
      pdf_folder = conference.get_pdf_folder_path
      FileUtils.mkdir_p pdf_folder
      new_file = pdf_folder + '/' + params[:fileData].original_filename

      File.open(new_file, 'wb') do |file|
        file.binmode
        file.puts(params[:fileData].read)
      end

      paper_pdf_path = new_file
      paper_params = paper_params(ActionController::Parameters.new(paper: parameters[:paper]))
      paper_params[:author] = paper_params[:author].split(';')
      paper_params[:affiliation] = paper_params[:affiliation].split(';')
      paper_params[:email] = paper_params[:email].split(';')

      Rails.logger.debug(paper_params)

      if PaperUtils.create_paper(paper_params, conference.id, paper_pdf_path).nil?
        render json: {status: :internal_server_error, message: 'Error creating new paper!'}
      elsif render json: {status: :ok, message: 'Paper was successfully added to your Conference.'}
      end
    else
      render json: {status: :internal_server_error, message: 'Please add a PDF of the Paper you are trying to upload!'}
    end
  end

  # Action used to show modal for paper deletion
  def delete
    render layout: false
  end

  # Action used to process and delete paper from system
  def destroy
    Paper.transaction do
      if @paper.destroy
        flash[:notice] = 'Paper has been successfully deleted.'
      else
        flash[:error] = 'Unable to delete Paper due to some error. Please try again later ...'
      end
    end
    redirect_back(fallback_location: root_path)
  end

  # Action used to update paper
  def update
    paper_params = paper_params()
    unless paper_params[:author].nil?
      paper_params[:author] = paper_params[:author].split(";")
    end
    unless paper_params[:affiliation].nil?
      paper_params[:affiliation] = paper_params[:affiliation].split(";")
    end
    unless paper_params[:email].nil?
      paper_params[:email] = paper_params[:email].split(";")
    end
    if @paper.update_attributes(paper_params)
      render json: {status: :success, text: @paper.title}
    else
      render json: {status: :error, text: @paper.title}
    end
  end

  private

  # Method used to permit allowed parameters for paper
  def paper_params(parameters=params)
    parameters.require(:paper).permit(:pdf, :title, :abstract, :year, :author, :affiliation, :email)
  end

  # Method used to set default paper
  def find_paper
    @paper = Paper.find(params[:id])
  end

end
