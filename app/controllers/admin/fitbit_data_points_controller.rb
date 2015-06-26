class Admin::FitbitDataPointsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    respond_to do |format|
      format.csv {render text: @user.fitbit_data_csv }
      format.html {render partial: 'show', method: @user.calendar_fitbit_events_array}
    end
  end
end