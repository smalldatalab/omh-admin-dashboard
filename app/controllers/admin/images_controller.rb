class Admin::ImagesController < ApplicationController
  def show
    @image = Mongoid::GridFs.get(params[:id])
    @filename = @image.filename
    @save_path = File.join(Rails.root.to_s + '/data')

    @temp = Tempfile.new(params[:id], @save_path)
    @data = File.read(File.join(@save_path + '/' + @filename))
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