class UsersController < ApplicationController
  def my_portfolio
    @tracked_stocks= current_user.stocks # current_user comes from devise gem
  end

  def my_friends
    @friends = current_user.friends
  end

  def friends_search
    render json: params[:friend]
  end
end
