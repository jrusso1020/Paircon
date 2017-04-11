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

  def create
    @paper = Paper.new(paper_params)
    if @paper.save
      if Conference.find(params[:conference_id]).conference_papers.create!(paper_id: @paper.id)
        PaperScrapperJob.perform_later(@paper, params[:conference_id])
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

  def destroy
    paper = Paper.find(params[:id])
    conferencePaper = ConferencePaper.find_by_paper_id(params[:id])
    Paper.transaction do
      if paper.destroy and conferencePaper.destroy
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
    params.require(:paper).permit(:pdf, :title, :author, :keywords, :year)
  end


end
