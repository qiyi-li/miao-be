class UsersController < ApplicationController
  def create
    user = Users.new  name:'gg'
    if user.save
      render json:user
    else 
      p json:user
      render  json:user.errors
    end

  end

  def show
    user = Users.find_by_id params[:id]
    if user
      render json:user
    else
      head 404
    end
  end
end
