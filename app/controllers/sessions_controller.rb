class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = "ログインしました"
      redirect_to users_url
    else
      flash.now[:danger] = 'メールアドレスもしくはパスワードが間違っています'
      render 'new'
    end
  end

  def easy_login
    user = User.find(1)
    log_in user
    flash[:success] = "サンプルユーザーでログインしました"
    redirect_to users_url
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
