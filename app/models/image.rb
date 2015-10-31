class Image < ActiveRecord::Base

  def get_image_from_mongodb(filename)
    @image_id = SurveyImage.find_by('metadata.media_id'=> filename)._id
    @image_file = Mongoid::GridFs.get(image_id)
  end

end
