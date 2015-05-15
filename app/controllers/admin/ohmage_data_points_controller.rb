class Admin::OhmageDataPointsController < ApplicationController
  def index
    @user   = User.find(params[:user_id])
    respond_to do |format|
      format.csv {render text: @user.ohmage_data_csv(current_admin_user.id)}
      format.html {render action: 'show', method: @user.calendar_ohmage_events_array(current_admin_user.id)}
    end
  end
end
