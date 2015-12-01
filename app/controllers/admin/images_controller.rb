class Admin::ImagesController < ApplicationController
  def show
    @image = Mongoid::GridFs.get(params[:id])
    @filename = @image.filename
    @save_path = '~/admindashboard/current/data'
    @file_path = File.join('~/admindashboard/current/data/' + @filename)

    @temp = Tempfile.new(params[:id], @save_path)
    @data = File.read(@file_path)
    # spawn 'rm -Rf ' + @filename
    begin
      File.open(params[:id], 'wb') do |f|
        f.write(@data)
      end
      send_file @image.path, type: @image.content_type, disposition: 'attachment'
    ensure
      @temp.close
      @temp.unlink
    end
  end
end