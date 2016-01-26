<h1>SDL ADMIN DASHBOARD - Manage Users' Data</h1>
<h5>Overview</h5>
<p>
  The admin dashboard is a web-based interface that enables the researchers (or clinicians) to setup, monitor, and retrieve data from authorized participants of their studies using a specified set of mobile health applications. It is one part of <a href="http://ohmage-omh.smalldata.io/">ohmage-omh</a> project, which is an open-source, open-architecture, mobile health platform intended for rapid prototyping and piloting of mobile health applications. The dashboard is integrated with Mobilty, ohmage, PAM, Moves and Fitbit apps and available for CSV and image data donwload.
</p>


<h5>Models</h5>
<h5>Migrations</h5>
<p></p>
<h5>Management User Types</h5>
<ul>
  <li>Super Admin</li>
  <li>Organizer</li>
  <li>Researcher</li>
</ul>

<h5>Available Panels</h5>
<ul>
  <li>Participants</li>
  <li>Organizations</li>
  <li>Studies</li>
  <li>Surveys</li>
  <li>Data Streams</li>
</ul>

<h5>Later Added On Functions</h5>
<p>
  SDL Admin Dashboard is a Ruby on Rails project. It uses <a href="http://activeadmin.info/">Active Admin</a>, a Ruby on Rails plugin for generating administration style interfaces. It intergates with ohmage-omh MongoDB using <a href="https://docs.mongodb.org/ecosystem/tutorial/ruby-mongoid-tutorial/">Mongoid</a>, a Ruby MongoDB Driver. You can edit config/mongoid.yml for changing database information.
</p>

<p>
  You should edit
</p>

<h5>Emails Sending</h5>
<p>
  It uses <a href="https://www.mandrill.com/">Mandrill</a> for sending emails. You need to create a username and password. Also, you can follow the instructions on Mandrill to set up a domain name for your email sender. Please edit config/application.rb.

  ```
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
  ```
</p>
<h5>Feature in Participant Panel</h5>
<ul>
  <li>Visualization for Daily Mobility Data</li>
  <li>Daily PAM Data</li>
  <li>Daily ohmage Data</li>
  <li>Annotation</li>
</ul>

