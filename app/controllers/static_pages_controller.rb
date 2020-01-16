class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: [:map]
  def home
  end

  def map
  end
end
