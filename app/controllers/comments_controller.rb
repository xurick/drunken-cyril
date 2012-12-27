class CommentsController < ApplicationController
  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(params[:comment])
    respond_to do |format|
      if @comment.valid?
        CommentMailer.comment_email(@comment).deliver
        format.js
      else
        format.js
      end
    end
  end
end
