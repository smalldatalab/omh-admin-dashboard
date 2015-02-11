class CalendarDataPointsController < ApplicationController 
  def index 
    @user = User.find(params[:user_id])
    respond_to do |format|
      format.json { render json: @user.calendar_data_json }
    end
  end 
end  