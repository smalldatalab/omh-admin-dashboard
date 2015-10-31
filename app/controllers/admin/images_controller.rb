class Admin::ImagesController < ApplicationController
  def show
    @image = Mongoid::GridFs.get(params[:id])
    send_data @image.data, type: @image.content_type, disposition: 'inline'
  end
end