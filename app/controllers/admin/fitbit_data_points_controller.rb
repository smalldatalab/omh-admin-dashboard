class Admin::FitbitDataPointsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    respond_to do |format|
      format.csv {render text: @user.fitbit_data_csv }
    end
  end
end