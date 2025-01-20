class StocksController < ApplicationController
  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      if @stock && @stock.name != "Unknown Company"
        respond_to do |format|
          format.turbo_stream { render partial: 'users/result' }# Turbo Stream ile sadece ilgili kısmı render et
        end
      else
        respond_to do |format|
          flash.now[:alert] = "Please enter a valid symbol to search"
          format.turbo_stream { render partial: 'users/result' }

        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a symbol to search"
        format.turbo_stream { render partial: 'users/result' }

      end
    end
  end
end
