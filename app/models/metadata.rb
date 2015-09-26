class Metadata
  include Mongoid::GridFs

  field :user_id, type: String

  embedded_in :survey_image, :inverse_of => :metadata

end