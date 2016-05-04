class AdminAuthorizations < ActiveAdmin::AuthorizationAdapter
  ### For authorization of Admin User Types
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
      when normalized(CustomUser)
        action == :read
  		else
  			true
  		end
    elsif user.organizer
      case subject
      when normalized(DataStream)
        false
      when normalized(Organization)
        false
      when normalized(CustomUser)
        action == :read || action == :create
      else
        true
      end
  	else
      case subject
      when normalized(CustomUser)
        action == :read || action == :create
      else
  		  true
      end
  	end
  end

  def scope_collection(collection, action = Auth::READ)
  	case collection.name
    when 'AdminUser'
      if user.researcher
        collection.where(:id => user.id)
      elsif user.organizer
        collection.joins(:organizations).where('organizations.id IN (?)', user.organizations.ids)
      else
        AdminUser
      end
  	when 'User'
  	  if user.researcher
        collection.joins(:studies).where('studies.id IN (?)', user.studies.ids).uniq
      elsif user.organizer
        collection.joins(:studies).where('studies.id IN (?)', Study.joins(:organizations).where('organizations.id IN (?)', user.organizations.ids).ids).uniq
  	  else
  	  	collection
  	  end
  	when 'ActiveAdmin::Comment'
  	  collection.where(:author_id => user.id)
    when 'Study'
      if user.researcher
        user.studies
      elsif user.organizer
        collection.joins(:organizations).where('organizations.id IN (?)', user.organizations.ids)
      else
        collection
      end
    when 'Survey'
      if user.researcher
        collection.joins(:studies).where('studies.id IN (?)', user.studies.ids).uniq
      elsif user.organizer
        collection.joins(:studies).where('studies.id IN (?)', Study.joins(:organizations).where('organizations.id IN (?)', user.organizations.ids).ids).uniq
      else
        collection
      end
    when 'CustomUser'
      if user.organizer
        collection.joins(:studies).where('studies.id IN (?)', Study.joins(:organizations).where('organizations.id IN (?)', user.organizations.ids).ids).uniq
      else
        collection
      end

  	else
  	  collection
  	end
  end
end
