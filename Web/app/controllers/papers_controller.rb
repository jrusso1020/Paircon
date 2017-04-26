require 'scrapper/pdf_scrapper'
class PapersController < ApplicationController
  include ConferencesHelper
  include PapersHelper
  before_action :authenticate_user!, except: [:validation]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def new
    @title = 'Add Paper'
    @body = 'Please enter the paper title and file upload path'
    render layout: false
  end

  def create
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

    if create_paper(paper_params, author_params, params[:conference_id], paper_pdf_path).nil?
      render status: :internal_server_error, json: {message: 'Error creating new paper!'}.to_json
    elsif
      render status: :ok, json: {message: 'Paper was successfully updated.'}.to_json
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
    if paper.update_attributes(paper_params)
      render json: {status: :success, text: paper.title}
    else
      render json: {status: :error, text: paper.title}
    end
  end

  def update_authors
    # TODO: find best way to update paper authors
  end

  private

  def set_user
    @user = current_user
  end

  def paper_params
    params.require(:paper).permit(:pdf, :title, :abstract, :year, :pdf_link)
  end

  def author_params
    params.require(:paper).permit(:author, :affiliation, :email)
  end


end
