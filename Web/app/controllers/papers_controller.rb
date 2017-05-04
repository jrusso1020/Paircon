require 'scrapper/pdf_scrapper'
require 'papers/paper_utils'
class PapersController < ApplicationController
  before_action :authenticate_user!, except: [:validation]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def new
    @title = 'Add Paper / Poster'
    @body = 'Please enter information about the Paper, optional details about the author(s) and upload a PDF version of the Paper.'
    render layout: false
  end

  def create
    if Paper::PAPER_MIME_TYPES.include?(params[:type])
      conference_id = params[:conference_id]
      paper_pdf_path = nil
      unless params[:filename].blank?
        pdf_folder = Rails.root.join('public', 'conference', conference_id, 'pdf')
        FileUtils.mkdir_p pdf_folder
        new_file = Rails.root.join('public', 'conference', conference_id, 'pdf/' + params[:filename])

        File.open(new_file, 'wb') do |file|
          file.binmode
          file.puts(request.body.read)
        end
        paper_pdf_path = new_file
      end
      paper_params = paper_params()
      paper_params[:author] = paper_params[:author].split(',')
      paper_params[:affiliation] = paper_params[:affiliation].split(',')
      paper_params[:email] = paper_params[:email].split(',')

      if PaperUtils.create_paper(paper_params, params[:conference_id], paper_pdf_path).nil?
        render status: :internal_server_error, json: {message: 'Error creating new paper!'}.to_json
      elsif
      render status: :ok, json: {message: 'Paper was successfully added to your Conference.'}.to_json
      end
    else
      render status: :internal_server_error, json: {message: 'Please add a PDF of the Paper you are trying to upload!'}.to_json
    end
  end

  def delete
    render layout: false
  end

  def destroy
    paper = Paper.find(params[:id])
    Paper.transaction do
      if paper.destroy
        flash[:notice] = 'Paper has been successfully deleted.'
      else
        flash[:error] = 'Unable to delete Paper due to some error. Please try again later ...'
      end
    end
    redirect_back(fallback_location: root_path)
  end

  def update
    paper = Paper.find(params[:id])
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
    if paper.update_attributes(paper_params)
      render json: {status: :success, text: paper.title}
    else
      render json: {status: :error, text: paper.title}
    end
  end

  private

  def set_user
    @user = current_user
  end

  def paper_params
    params.require(:paper).permit(:pdf, :title, :abstract, :year, :author, :affiliation, :email)
  end


end
