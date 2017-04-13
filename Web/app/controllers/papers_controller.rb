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
    paper_params[:year] = DateTime.new(paper_params[:year])
    @paper = Paper.new(paper_params)
    if @paper.save
      unless params[:filename].blank?
        @paper.save_pdf(params[:conference_id], params[:filename], request.body)
      end
      unless author_params[:author].blank?
        count = 0
        affiliation_arr = Array.new
        unless author_params[:affiliation].blank?
          affiliation_arr = author_params[:affiliation].split(',')
        end
        length = affiliation_arr.size
        for author in author_params[:author].split(',')
          affiliation = ""
          if length > count
            affiliation = affiliation_arr[count]
          end
          count += 1
          if not @paper.paper_authors.create!({name: author, affiliation: affiliation})
            render status: :internal_server_error, json: {message: 'Error creating new paper!'}.to_json
          end
        end
      end
      if Conference.find(params[:conference_id]).conference_papers.create!(paper_id: @paper.id)
        begin
          PaperScrapperJob.perform_later(@paper, params[:conference_id])
        rescue => e
          extractTextFromPdf(@paper, params[:conference_id])
        end
        render status: :ok, json: {message: 'Paper was successfully updated.'}.to_json
      else
        render status: :internal_server_error, json: {message: 'Error creating new paper!'}.to_json
      end
    else
      render status: :internal_server_error, json: {message: 'Error creating new paper!'}.to_json
    end
  end

  def delete
    render layout: false
  end

  def destroy
    paper = Paper.find(params[:id])
    #conferencePaper = ConferencePaper.find_by_paper_id(params[:id])
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

  private

  def set_user
    @user = current_user
  end

  def paper_params
    params.require(:paper).permit(:pdf, :title, :keywords, :year)
  end

  def author_params
    params.require(:paper).permit(:author, :affiliation)
  end


end
