class Survey < ActiveRecord::Base
  before_save :set_search_key_name

  has_many :studies, through: :s_surveys
  has_many :s_surveys

  validates :studies, presence: true

  ### For automatically adding search key name
  def set_search_key_name
    survey_definition = self.definition
    definition_json = JSON.parse(survey_definition)
    self.search_key_name = definition_json['schema_id']['name']
  end
end