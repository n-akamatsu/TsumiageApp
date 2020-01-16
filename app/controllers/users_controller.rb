class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                          :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :sample_user,    only: [:edit, :update]

  def index
    @tsumiages = Tsumiage.order(created_at: :desc).order(:user_id).limit(100)
  end

  def show
    @user = User.find(params[:id])
    # 検索されているとき
    if params[:date]
      if @user.tsumiages.where(created_at: params[:date].in_time_zone.all_day).any?
        @tsumiages = @user.tsumiages.where(created_at: params[:date].in_time_zone.all_day)
      else
        @tsumiages = @user.tsumiages.order(created_at: :desc)
        @alert = "その日の積み上げはありません"
      end
    # 検索されていないとき
    else
      @tsumiages = @user.tsumiages.order(created_at: :desc)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "新規登録しました"
      redirect_to users_url
    else
      flash[:danger] = "登録に失敗しました。正しく入力してください"
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to users_url
    else
      flash[:danger] = "更新に失敗しました。正しく入力してください"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザー登録を削除しました"
    redirect_to root_url
  end

  
  def analysis
    @user = User.find_by(id: params[:id])
    @day = Date.today
    @total_time = @user.tsumiages.where(created_at: @day.in_time_zone.all_day).sum(:time)
    @tsumiage_table = @user.tsumiages.where(created_at: @day.in_time_zone.all_day).group(:genre).order(time: :desc).order(created_at: :desc).sum(:time).sort_by{| k,v | v}.reverse
    if @user.tsumiages.any?
      @most_tsumiage = @user.tsumiages.group(:genre).sum(:time).sort_by{| k,v | v}.reverse.first
      @average_tsumiage = (@user.tsumiages.sum(:time)) / (@user.tsumiages.group(:created_at).count.length)
    end

    @circle_chart = @user.tsumiages.where(created_at: @day.in_time_zone.all_day).group(:genre).order(time: :desc).order(created_at: :desc).sum(:time).sort_by{| k,v | v}.reverse
    @column_chart = @user.tsumiages.order(created_at: :asc).group_by_day(:created_at).sum(:time)
  end

  def analysis_day
    @user = User.find_by(id: params[:id])
    @day = params[:user][:day]
    @total_time = @user.tsumiages.where(created_at: @day.in_time_zone.all_day).sum(:time)
    @tsumiage_table = @user.tsumiages.where(created_at: @day.in_time_zone.all_day).group(:genre).order(time: :desc).order(created_at: :desc).sum(:time).sort_by{| k,v | v}.reverse
    if @user.tsumiages.any?
      @most_tsumiage = @user.tsumiages.group(:genre).sum(:time).sort_by{| k,v | v}.reverse.first
      @average_tsumiage = (@user.tsumiages.sum(:time)) / (@user.tsumiages.group(:created_at).count.length)
    end
    
    @circle_chart = @user.tsumiages.where(created_at: @day.in_time_zone.all_day).group(:genre).order(time: :desc).order(created_at: :desc).sum(:time).sort_by{| k,v | v}.reverse
    @column_chart = @user.tsumiages.order(created_at: :asc).group_by_day(:created_at).sum(:time)
  end

  def analysis_week_normal
    @user = User.find_by(id: params[:id])
    @day_show = Date.today.next_week
    @day = Date.today
    @week = @day_show.strftime('%Y-W%W')
    @total_time = @user.tsumiages.where(created_at: @day.in_time_zone.all_week).sum(:time)
    @tsumiage_table = @user.tsumiages.where(created_at: @day.in_time_zone.all_week).group(:genre).order(time: :desc).order(created_at: :desc).sum(:time).sort_by{| k,v | v}.reverse
    @circle_chart = @user.tsumiages.where(created_at: @day.in_time_zone.all_week).group(:genre).order(time: :desc).order(created_at: :desc).sum(:time).sort_by{| k,v | v}.reverse
    @column_chart = @user.tsumiages.order(created_at: :asc).group_by_week(:created_at).sum(:time)
  end

  def analysis_week
    @user = User.find_by(id: params[:id])
    @week = params[:user][:week]
    @week_to_date = @week.to_date
    @total_time = @user.tsumiages.where(created_at: @week_to_date.in_time_zone.all_week).sum(:time)
    @tsumiage_table = @user.tsumiages.where(created_at: @week_to_date.in_time_zone.all_week).group(:genre).order(time: :desc).order(created_at: :desc).sum(:time).sort_by{| k,v | v}.reverse
    @circle_chart = @user.tsumiages.where(created_at: @week_to_date.in_time_zone.all_week).group(:genre).order(time: :desc).order(created_at: :desc).sum(:time).sort_by{| k,v | v}.reverse
    @column_chart = @user.tsumiages.order(created_at: :asc).group_by_week(:created_at).sum(:time)
  end

  def analysis_month_normal
    @user = User.find_by(id: params[:id])
    @day = Date.today
    @month = @day.strftime('%Y-%m')
    # strftimeを用いて'2019-12'を作って代入
    @total_time = @user.tsumiages.where(created_at: @day.in_time_zone.all_month).sum(:time)
    @tsumiage_table = @user.tsumiages.where(created_at: @day.in_time_zone.all_month).group(:genre).order(time: :desc).order(created_at: :desc).sum(:time).sort_by{| k,v | v}.reverse
    @circle_chart = @user.tsumiages.where(created_at: @day.in_time_zone.all_month).group(:genre).order(time: :desc).order(created_at: :desc).sum(:time).sort_by{| k,v | v}.reverse
    @column_chart = @user.tsumiages.order(created_at: :asc).group_by_month(:created_at).sum(:time)
  end

  def analysis_month
    @user = User.find_by(id: params[:id])
    @month = params[:user][:month]
    @month_to_date = @month+'-1'
    # 文字列を足して'2019-12-1'を作り出した。@month.to_dateが使えなかったため
    @total_time = @user.tsumiages.where(created_at: @month_to_date.in_time_zone.all_month).sum(:time)
    @tsumiage_table = @user.tsumiages.where(created_at: @month_to_date.in_time_zone.all_month).group(:genre).order(time: :desc).order(created_at: :desc).sum(:time).sort_by{| k,v | v}.reverse
    @circle_chart = @user.tsumiages.where(created_at: @month_to_date.in_time_zone.all_month).group(:genre).order(time: :desc).order(created_at: :desc).sum(:time).sort_by{| k,v | v}.reverse
    @column_chart = @user.tsumiages.order(created_at: :asc).group_by_month(:created_at).sum(:time)
  end


  def close
    @tsumiage_id = params[:tsumiage_id]

    respond_to do |format|
      format.html { redirect_to users_url }
      format.js
    end
  end


    private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :picture)
      end

      # beforeアクション

      # 正しいユーザーかどうかを確認
      def correct_user
        @user = User.find(params[:id])
        redirect_to(root_url) unless current_user?(@user)
        # current_user?(@user): helperで設定した関数。正しいユーザーかどうか確認する
      end

      # サンプルユーザーが登録編集をすることを防ぐ
      def sample_user
        if current_user.id == 1
          flash[:danger] = "サンプルユーザーはアカウント編集ができません"
          redirect_to users_url
        end
      end
end
