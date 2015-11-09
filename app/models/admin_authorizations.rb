class AdminAuthorizations < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
  	if user.researcher
  		case subject
  		when normalized(Study)
  			action == :read
      when normalized(DataStream)
        false
      when normalized(Survey)
        action == :read
      when normalized(AdminUser)
        action == :read || action == :update
      when normalized(User)
        action == :read
      when normalized(Organization)
        false
  		else
  			true
  		end
    elsif user.organizer
      case subject
      when normalized(DataStream)
        false
      when normalized(Organization)
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
    when 'AdminUser'
      if user.researcher
        collection.where(:id => user.id)
      elsif user.organizer
        collection.where(:organization_id => user.organization)
      else
        AdminUser
      end
  	when 'User'
  	  if user.researcher
        user.users
      elsif user.organizer
        user.organization.users
  	  else
  	  	collection
  	  end
  	when 'ActiveAdmin::Comment'
  	  collection.where(:author_id => user.id)
    when 'Study'
      if user.researcher
        user.studies
      elsif user.organizer
        user.organization.studies
      else
        collection
      end
    when 'Survey'
      if user.researcher
        user.surveys
      elsif user.organizer
        user.organization.surveys
      else
        collection
      end
  	else
  	  collection
  	end
  end
end
