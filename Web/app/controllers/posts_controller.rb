class PostsController < ApplicationController
  before_action :find_post, only: [:edit, :update, :show, :delete, :destroy]
  before_action :authenticate_user!, except: [:validation]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.where(conference_id: params[:conference_id])
  end

  def create
    @post = Post.new(post_params)
    @post.conference_id = params[:conference_id]

    if @post.save
      flash[:notice] = 'Your Post has successfully been added and published.'
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = 'Error creating your Post! Please contact our support team.'
      redirect_back(fallback_location: root_path)
    end

  end

  def update
    if @post.update_attributes(post_params)
      render json: {status: :success, text: @post.conference.name}
    else
      render json: {status: :error, text: @post.conference.name}
    end
  end

  def show
  end

  def delete
    render layout: false
  end

  # The destroy action removes the conference permanently from the database
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

  def set_user
    @user = current_user
  end

  def post_params
    params.require(:post).permit!
  end

  def find_post
    @post = Post.find(params[:id])
  end

end
