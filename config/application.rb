require File.expand_path('../boot', __FILE__)

require 'csv'
require 'rails/all'
require 'rails/mongoid'
require 'json'
require 'rack/gridfs'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

ENV.update YAML.load_file('config/application.yml')[Rails.env] rescue {}

module SdlAdminDashboard
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.middleware.use Rack::GridFS, :hostname => 'http://lifestreams.smalldata.io', :port => 27017, :database => Mongoid.session('default'), :prefix => 'gridfs'
    config.generators.orm :active_record
    initializer 'setup_asset_pipeline', :group => :all do |app|
      app.config.assets.precompile.shift
      app.config.assets.precompile.push(Proc.new do |path|
        File.extname(path).in? [
          '.html', '.erb', '.haml',                 # Templates
          '.png',  '.gif', '.jpg', '.jpeg',         # Images
          '.eot',  '.otf', '.svc', '.woff', '.ttf', # Fonts
        ]
      end)
    end

    config.action_mailer.default_url_options = {:host => ENV['MANDRILL_HOST'] || Rails.application.secrets.MANDRILL_HOST}
    config.action_mailer.default :charset => "utf-8"
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:                 'smtp.mandrillapp.com',
      port:                     587,
      domain:                  'smalldata.io',
      user_name:               ENV['MANDRILL_USERNAME'] || Rails.application.secrets.MANDRILL_USERNAME,
      password:                ENV['MANDRILL_PASSWORD'] || Rails.application.secrets.MANDRILL_PASSWORD,
      authentication:          'plain',
      enable_starttls_auto:     true
    }
  end
end


