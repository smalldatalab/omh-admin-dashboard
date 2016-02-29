class Admin::MobilityDailySummaryDataPointsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    respond_to do |format|
       format.csv {render text: @user.mobility_daily_summary_data_csv }
       tracer_bullet
    end
  end
end