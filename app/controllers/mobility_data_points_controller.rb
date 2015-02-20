class Admin::MobilityDataPointsController < ApplicationController
  def index
  	@user = User.find(params[:user_id])
  	respond_to do |format|
       format.csv {render text: @user.mobility_data_csv }
    end
  end 
end
