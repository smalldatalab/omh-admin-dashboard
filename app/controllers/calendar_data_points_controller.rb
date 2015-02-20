class Admin::CalendarDataPointsController < ApplicationController 

  def all_calendar_data_points
    file = File.read('data/data.json')
    data = JSON.parse(file)
  end  
  def index 
    @user = User.find(params[:user_id])
    respond_to do |format|
      format.json { render json: @user.calendar_data_json }
    end
  end 
end  