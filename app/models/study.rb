class Study < ActiveRecord::Base
  # attr_accessible :name
  has_many :admin_users, through: :study_owners
  has_many :study_owners

  has_many :users, through: :study_participants
  has_many :study_participants


  # study_names = Study.all.map {|a| a.name}
  
  def self.all_names
  	all.map {|a| a.name} 
  end

end
