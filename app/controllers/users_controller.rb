class UsersController < ApplicationController
  def create
    user = User.new email:'lll@yyy.com', name:'小李'
    if user.save
      render json:user
    else  
      p 'save fail'
    end
  end

  def show
    p 'this is show'
  end
end
