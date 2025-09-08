class UsersController < ApplicationController
  def index
    @users = User.includes(:trades).all
  end
end