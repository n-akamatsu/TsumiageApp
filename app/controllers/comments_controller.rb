class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @comment = Comment.new(user_id: current_user.id, post_id: params[:tsumiage_id], content: params[:comment][:content])
    @comment.save
    @comments_count = Comment.where(post_id: params[:tsumiage_id]).count

    @tsumiage_id = params[:tsumiage_id]

    respond_to do |format|
      format.html { redirect_to users_url }
      format.js
    end
  end

  def destroy
    @comment = Comment.find_by(user_id: current_user.id, post_id: params[:tsumiage_id])
    @comment.destroy
    @comments_count = Comment.where(post_id: params[:tsumiage_id]).count

    @tsumiage_id = params[:tsumiage_id]

    respond_to do |format|
      format.html { redirect_to users_url }
      format.js
    end
  end

  def edit
  end

  def open
    @tsumiage_id = params[:tsumiage_id]

    respond_to do |format|
      format.html { redirect_to users_url }
      format.js
    end
  end

  def close
    @tsumiage_id = params[:tsumiage_id]

    respond_to do |format|
      format.html { redirect_to users_url }
      format.js
    end
  end
end
