class PamDataPointsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    respond_to do |format|
      format.csv {render text: @user.pam_data_csv }
      format.html {render action: 'show'}
    end
  end
end
