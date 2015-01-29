class AdminAuthorizations < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
  	if user.researcher
  		case subject
  		when normalized(Study)
  			false
      when normalized(DataStream)
        false 
  		when normalized(AdminUser)
  			false
  		else
  			true
  		end
  	else
  		true
  	end
  end

  def scope_collection(collection, action = Auth::READ)
  	case collection.name
  	when 'User'
  	  if user.researcher
  	  	user.users
  	  else
  	  	collection
  	  end
  	when 'ActiveAdmin::Comment'
  	  collection.where(:author_id => user.id)
    # when 'Study'
    #   if user.researcher 
    #     user.studies.name
    #   else 
    #     collection
    #   end
    # when 'DataStream'
    #   if user.researcher
    #      user.data_streams.name
    #   else 
    #     collection
    #   end
  	else
  	  collection
  	end
  end
end
