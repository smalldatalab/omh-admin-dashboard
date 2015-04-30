class AdminAuthorizations < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
  	if user.researcher
  		case subject
  		when normalized(Study)
  			action == :read
      when normalized(DataStream)
        false
      when normalized(Survey)
        action == :read || action == :create
      when normalized(AdminUser)
        action == :read || action == :update
      when normalized(User)
        action == :read
  		else
  			true
  		end
  	else
  		true
  	end
  end

  def scope_collection(collection, action = Auth::READ)
  	case collection.name
    when 'AdminUser'
      if user.researcher
        collection.where(:id => user.id)
      else
        AdminUser
      end
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
    when 'Survey'
      if user.researcher
        user.surveys
      else
        collection
      end
  	else
  	  collection
  	end
  end
end
