class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_creator, only: [:edit, :update]

  def index
    @posts = Post.all.sort_by { |post| post.total_votes }.reverse

    respond_to do |format|
      format.html
      format.json { render json: @posts.to_json(only: [:title, :description]) }
      format.xml { render xml: @posts.to_xml(only: [:title]) }
    end
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user
    if @post.save
      flash[:notice] = "Your new post was created."
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      flash[:notice] = "Your post has been updated!"
      redirect_to posts_path 
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])
    
    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = "Your vote was counted."
        else
          flash[:error] = "You can only vote once for <strong>#{@post.title}</strong>.".html_safe
        end
        redirect_to :back
      end
      format.js 
    end
  end

  private
    def post_params
      params.require(:post).permit(:title, :url, :description, :category_ids => [])
    end

    def set_post
      @post = Post.find_by(slug: params[:id])
    end

    def require_same_creator
      if current_user != @post.creator
        flash[:error] = "This action is not allowed."
        redirect_to root_path
      end
    end
end
