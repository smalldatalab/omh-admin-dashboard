class Admin::PamDataPointsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    respond_to do |format|
      format.csv {render text: @user.pam_data_csv }
      format.html {render partial: 'show', method: @user.calendar_pam_events_array}
    end
  end
end
