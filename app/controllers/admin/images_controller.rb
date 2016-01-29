class Admin::ImagesController < ApplicationController
  def show
    image = Mongoid::GridFs.get(params[:id])
    filename = image.filename
    csv_filename = image.metadata["media_id"]
    send_data image.data, filename: csv_filename, type: image.content_type, disposition: 'attachment'
  end
end