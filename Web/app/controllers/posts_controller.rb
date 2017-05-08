# Controller primarily responsible for handling Posts
class PostsController < ApplicationController
  before_action :find_post, only: [:edit, :update, :show, :delete, :destroy]
  before_action :authenticate_user!, except: [:index]

  # Action used to show list of posts with loading on scrolling
  def index
    @is_organizer = user_signed_in? and Conference.find_by_id(params[:conference_id]).is_organizer(current_user)
    @posts = Post.where(conference_id: params[:conference_id]).page(params[:page]).order(created_at: :desc)
    respond_to do |format|
      format.html
      format.js
    end
  end

  # Action used to create post
  def create
    @post = Post.new(post_params)
    @post.conference_id = params[:conference_id]

    if @post.save
      flash[:notice] = 'Your Post has successfully been added and published.'
      redirect_back(fallback_location: root_path)
      @post.activity(:create, current_user)
    else
      flash[:alert] = 'Error creating your Post! Please contact our support team.'
      redirect_back(fallback_location: root_path)
    end

  end

  # Action used to update post
  def update
    if @post.update_attributes(post_params)
      render json: {status: :success, text: @post.conference.name}
    else
      render json: {status: :error, text: @post.conference.name}
    end
  end

  # Action used to show modal for post deletion
  def delete
    render layout: false
  end

  # Action used to remove post permanently from system
  def destroy
    Post.transaction do
      if @post.destroy
        flash[:notice] = 'Post has been successfully deleted.'
      else
        flash[:error] = 'Unable to delete Post due to some error. Please try again later ...'
      end
    end
    redirect_back(fallback_location: root_path)
  end

  private

  # Method used to permit only allowed post parameters
  def post_params
    params.require(:post).permit!
  end

  # Method used to find default post based on Parameter ID
  def find_post
    @post = Post.find(params[:id])
  end

end
