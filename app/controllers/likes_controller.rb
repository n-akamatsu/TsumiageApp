class LikesController < ApplicationController
  before_action :logged_in_user

  def create
    @like = Like.new(user_id: current_user.id, post_id: params[:tsumiage_id])
    @like.save
    @likes_count = Like.where(post_id: params[:tsumiage_id]).count
    @tsumiage_id = params[:tsumiage_id]
    respond_to do |format|
      format.html { redirect_to users_url }
      format.js
    end
  end

  def destroy
    @like = Like.find_by(user_id: current_user.id, post_id: params[:tsumiage_id])
    @like.destroy
    @likes_count = Like.where(post_id: params[:tsumiage_id]).count
    @tsumiage_id = params[:tsumiage_id]
    respond_to do |format|
      format.html { redirect_to users_url }
      format.js
    end
  end
end
