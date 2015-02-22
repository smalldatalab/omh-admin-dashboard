class AdminAuthorizations < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
  	if user.researcher
  		case subject
  		when normalized(Study)
  			action == :read
      when normalized(DataStream)
        false
      when normalized(Survey)
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
    when 'Study'
      if user.researcher 
        user.studies
      else 
        collection
      end
    # when 'DataStream'
    #   if user.researcher
    #      user.admin_streams
    #   else 
    #     collection
    #   end
    # when 'Survey'
    #   if user.researcher
    #     user.admin_surveys
    #   else 
    #     collection 

  	else
  	  collection
  	end
  end
end
