class CommentsController < ApplicationController
  before_action :require_user
  
  def create 
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(params.require(:comment).permit(:body))
    @comment.creator = current_user
    if @comment.save
      flash[:notice] = "You just created a new comment."
      redirect_to post_path(@post)
    else
      render "posts/show"
    end
  end

  def vote
    @comment = Comment.find(params[:comment_id])
    @vote = Vote.create(voteable: @comment, creator: current_user, vote: params[:vote])
    if @vote.valid?
      flash[:notice] = "Your vote was counted."
    else
      flash[:error] = "Your can only vote once for this comment."
    end
    redirect_to :back
  end
end