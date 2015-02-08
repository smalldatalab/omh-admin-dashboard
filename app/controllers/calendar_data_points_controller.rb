class CalendarDataPointsController < ApplicationController 
  def index 
    @user = User.find(params[:user_id])
    respond_to do |format|
      format.json { render json: @user.all_calendar_data_points }
    end
  end 
end  