class Admin::ImagesController < ApplicationController
  def show
    @image = Mongoid::GridFs.get(params[:id])
    @filename = @image.filename
    @temp = Tempfile.new(params[:id])
    @data = File.read(@filename)

    begin
      File.open(params[:id], 'wb') do |f|
        f.write(@data)
      end
      send_file @image.path, type: @image.content_type, disposition: 'attachment'
    ensure
      @temp.close
      @temp.unlink
      spawn 'rm -Rf ' + @filename
    end
  end


end