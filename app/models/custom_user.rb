class CustomUser < ActiveRecord::Base
  has_secure_password
  # validates_uniqueness_of :username
  validates :studies, presence: true
  validate :checkPOSTStatus, on: :create

  has_many :custom_studies
  has_many :studies, through: :custom_studies

  def checkPOSTStatus
    ### Push users to endUser collection in mongodb using API
    uri = URI("http://aws-qa.smalldata.io/dsu/internal/users")
    req = Net::HTTP::Post.new(uri)
    req.content_type = 'application/json'
    req.body = {'username' => self.username, 'password' => self.password}.to_json
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    
    ### check for the status and only resturn true when it is 200OK
    case res
    when Net::HTTPOK
      return true
    else 
      errors.add(:username, "Please enter an unique username")
    end
  end 

end