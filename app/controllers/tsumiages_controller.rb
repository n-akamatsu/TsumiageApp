class TsumiagesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def new
    @tsumiage = Tsumiage.new
  end

  def create
    @tsumiage = current_user.tsumiages.build(tsumiage_params)
    @day = Date.today
    if @tsumiage.save && params[:tsumiage][:more_tsumiage] == '1'
      # 投稿の作成時間を各日ごとに統一することで「#今日の積み上げ」をまとめて表示することを可能にした
      if current_user.tsumiages.where(created_at: @day.in_time_zone.all_day)
        @update_time = @tsumiage.created_at
        current_user.tsumiages.where(created_at: @day.in_time_zone.all_day).update_all(created_at: @update_time)
      end
      flash[:success] = "もう一つ積み上げよう!"
      redirect_to new_tsumiage_url
    elsif @tsumiage.save && params[:tsumiage][:more_tsumiage] == '0'
      if current_user.tsumiages.where(created_at: @day.in_time_zone.all_day)
        @update_time = @tsumiage.created_at
        current_user.tsumiages.where(created_at: @day.in_time_zone.all_day).update_all(created_at: @update_time)
      end
      flash[:success] = "「＃今日の積み上げ」を投稿しました"
      redirect_to user_path(current_user)
    else
      flash[:danger] = "投稿に失敗しました。すべて入力してください"
      redirect_to new_tsumiage_url
    end
  end

  def destroy
    @tsumiage.destroy
    flash[:success] = "「みんなの投稿」が削除されました"
    redirect_to request.referrer || root_url
    # request.referrer  このメソッドは一つ前のURLを返します
  end

  private

    def tsumiage_params
      params.require(:tsumiage).permit(:content, :time, :genre)
    end

    def correct_user
      @tsumiage = current_user.tsumiages.find_by(id: params[:id])
      redirect_to root_url if @tsumiage.nil?
    end
end
