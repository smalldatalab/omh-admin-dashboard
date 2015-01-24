class Study < ActiveRecord::Base
  # attr_accessible :name
  belongs_to :admin_user
  belongs_to :user 

  # study_names = Study.all.map {|a| a.name}
  
  def self.all_names
  	all.map {|a| a.name} 
  end

end
