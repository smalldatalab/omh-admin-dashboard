class Admin::MobilityUserInterfaceController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    respond_to do |format|
      format.html {render partial: 'show'}
    end
  end
end
