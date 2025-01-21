class UsersController < ApplicationController
  def my_portfolio
    @tracked_stocks= current_user.stocks # current_user comes from devise gem
  end
end
