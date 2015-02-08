# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( user.js )
Rails.application.config.assets.precompile += %w( fullcalendar.css )
Rails.application.config.assets.precompile += %w( calendar.css )
# Rails.application.config.assets.precompile += %w( bootstrap.min.css )
Rails.application.config.assets.precompile += %w( jquery.min.js )
Rails.application.config.assets.precompile += %w( d3.min.js )
Rails.application.config.assets.precompile += %w( bootstrap.min.js )
Rails.application.config.assets.precompile += %w( moment.min.js )
Rails.application.config.assets.precompile += %w( fullcalendar.js )
Rails.application.config.assets.precompile += %w( gcal.js )
Rails.application.config.assets.precompile += %w( fullcalendar_implementation.js )

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
