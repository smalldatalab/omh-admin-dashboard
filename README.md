<h1>SDL ADMIN DASHBOARD - Manage Users' Data</h1>
<h4>Overview</h4>
<p>
  The admin dashboard is a web-based interface that enables the researchers (or clinicians) to setup, monitor, and retrieve data from authorized participants of their studies using a specified set of mobile health applications. It is one part of <a href="http://ohmage-omh.smalldata.io/">ohmage-omh</a> project, which is an open-source, open-architecture, mobile health platform intended for rapid prototyping and piloting of mobile health applications. The dashboard is integrated with Mobilty, ohmage, PAM, Moves and Fitbit apps and available for CSV and image data donwload.
</p>

<h4>Background</h4>
<p>
  SDL Admin Dashboard is a Ruby on Rails project. It uses <a href="http://activeadmin.info/">Active Admin</a>, a Ruby on Rails plugin for generating administration style interfaces. It intergates with ohmage-omh MongoDB using <a href="https://docs.mongodb.org/ecosystem/tutorial/ruby-mongoid-tutorial/">Mongoid</a>, a Ruby MongoDB Driver. You can edit config/mongoid.yml for changing database information.
</p>
<ul>
  <li>Ruby on Rails</li>
  <li>Active Admin</li>
  <li>d3</li>
  <li>Mongodb</li>
  <li>Mongoid</li>
</ul>


<h4>Built-in Active Admin Functions</h4>
<h5>Controllers</h5>
<p></p>
<h5>Models</h5>
<h5>Views</h5>
<h5>Migrations</h5>
<p></p>
<h5>config</h5>

<h4>Later Added On Functions (Customized)</h4>

<h5>Feature in Admin User Panel</h5>
<h5>Authorization</h5>
<p>Edit models/admin_authoriations.rb for Admin User type's access. See <a href="http://activeadmin.info/docs/13-authorization-adapter.html">here</a> for more information. If you want to edit the content of each individual panel, edit individual file under app/admin. </p>

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
<p>models/admin_user.rb</p>

<h5>Feature in Participant Panel</h5>
<ul>
  <li>Calendar</li>
  <p>The calendar is built with <a href="http://fullcalendar.io/">FullCalendar</a>, an open source JavaScript jQuery plugin for a full-sized, drag & drop event calendar. Eidt assets/fullcalendar_implementation.js</p>
  <ul>
    <li>Graph</li>
    <p>The graph is built with <a href="http://d3js.org/">D3</a>, a JavaScript library for visualizing data with HTML, SVG, and CSS. It renders three aspects of the daily summarized Mobility data, "Time Not At Home", "Active Time" and "Max Speed".</p>
    <li>One Day Data</li>
    <p>models/user.rb</p>
    <p>controllers/pam_data_points_controller.rb</p>
    <p>controllers/ohmage_data_points_controller.rb</p>
    <p>controllers/fitbit_data_points_controller.rb</p>
    <li>Image download</li>
    <p>controllers/images_controller.rb</p>
    <li>Annotation</li>
    <p>annotation_controller.rb</p>
  </ul>
  <li>CSV File Download</li>
</ul>

<h5>Survey</h5>
<p>models/survey.rb</p>

<h5>Custom Users</h5>

<h5>Data Integration</h5>
<ul>
  <li>Mongodb</li>
  <p>config/mongoid.yml</p>
  <p>In order to call the attributes in the mongodb, you need to set each attribute as a class under models folder to establish the relationship.</p>
  <li>Postgres</li>
  <p>Active Admin is built in with Postgres and migration is automated. Run "rails g active_record:migration xxxxxxxx" for adding migration.</p>
</ul>


