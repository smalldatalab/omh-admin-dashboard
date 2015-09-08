class Admin::LogInDataPointsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    respond_to do |format|
      format.csv {render text: @user.log_in_data_csv}
    end
  end
end
