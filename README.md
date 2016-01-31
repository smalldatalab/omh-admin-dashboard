<h1>SDL ADMIN DASHBOARD - Manage Users' Data</h1>
<h4>Overview</h4>
<p>
  The admin dashboard is a web-based interface that enables the researchers (or clinicians) to setup, monitor, and retrieve data from authorized participants of their studies using a specified set of mobile health applications. It is one part of <a href="http://ohmage-omh.smalldata.io/">ohmage-omh</a> project, which is an open-source, open-architecture, mobile health platform intended for rapid prototyping and piloting of mobile health applications. The dashboard is integrated with Mobilty, ohmage, PAM, Moves and Fitbit apps and available for CSV and image data donwload.
</p>

<h4>Background</h4>
<p>
  SDL Admin Dashboard is a Ruby on Rails project. It uses <a href="http://activeadmin.info/">Active Admin</a>, a Ruby on Rails plugin for generating administration style interfaces. It intergates with ohmage-omh MongoDB using <a href="https://docs.mongodb.org/ecosystem/tutorial/ruby-mongoid-tutorial/">Mongoid</a>, a Ruby MongoDB Driver. You can edit config/mongoid.yml for changing database information. See Gemfile for a complete list of gems used in the project.
</p>

<ul>
  <li>Ruby on Rails</li>
  <li>Active Admin</li>
  <li>Mongodb</li>
  <li>Mongoid</li>
  <li>d3</li>
  <li>JavaScript</li>
</ul>

<h4>Built-in Active Admin Functions</h4>
<p>Active Admin brought with the set of framework including controller, models, views and migration for Admin USer and Users. Please see Active Admin main page for more information.</p>

<h4>Later Added On Functions (Customized)</h4>
<h5>Feature in Admin User Panel</h5>
<h5>Authorization</h5>
<p>Edit models/admin_authoriations.rb for Admin User type's access. See <a href="http://activeadmin.info/docs/13-authorization-adapter.html">here</a> for more information. If you want to edit the content of each individual panel, edit individual file under app/admin.</p>

<h5>Emails Sending</h5>
<p>
  It uses <a href="https://www.mandrill.com/">Mandrill</a> for sending emails. You need to create a username and password. Also, you can follow the instructions on Mandrill to set up a domain name for your email sender. Please edit config/application.rb.
</p>

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
        
<p>models/admin_user.rb</p>

<h5>Feature in Participant Panel</h5>
<ul>
  <li>Calendar</li>
  <p>The calendar is built with <a href="http://fullcalendar.io/">FullCalendar</a>, an open source JavaScript jQuery plugin for a full-sized, drag & drop event calendar. The codebase is in assets/fullcalendar_implementation.js</p>
  <ul>
    <li>Graph</li>
    <p>The graph is built with <a href="http://d3js.org/">D3</a>, a JavaScript library for visualizing data with HTML, SVG, and CSS. It renders three aspects of the daily summarized Mobility data, "Time Not At Home", "Active Time" and "Max Speed". See assets/fullcalendar_implementation.js for more information.</p>
    <li>One Day Data</li>
    <p>One day data array of all three data streams, PAM, ohmage ang Fitbit are handled by in the models/user.rb and the arrays are rendered as events on the calendar of individual partcipant. The event also has a hyperlink that will direct to a page that shows the data for that date. </br>
    Take ohmage survey data as an example, in models/user.rb the ohmage data for one specific participant get collected.
    </p>
    
```ruby
    def one_day_ohmage_data_points(admin_user_id, date)
      if @user_record.nil?
        return nil
      else
        ohmage_data_points = @user_record.pam_data_points.where('header.acquisition_provenance.source_name' => /^Ohmage/,'header.acquisition_provenance.modality' => 'SELF_REPORTED', 'header.creation_date_time' => date)
        if ohmage_data_points.last.nil?
          return nil
        else
          if AdminUser.find(admin_user_id).researcher?
            admin_surveys = []
            AdminUser.find(admin_user_id).surveys.each do |a|
              admin_surveys.push(a.search_key_name)
            end
            ohmage_data_points.where('header.schema_id.name' => { '$in' => admin_surveys})
          else
            ohmage_data_points
          end
        end
      end
    end
```
        
    <p>Then the following function turns the data in the JSON format that could be read by the fullcalendar JavaScript plugin.</p>
    
    ```
    def calendar_ohmage_events_array(admin_user_id)
      ohmage_events_array = []
      ohamge_events_date = []
      if all_ohmage_data_points(admin_user_id).nil?
        return nil
      else
        all_ohmage_data_points(admin_user_id).each do |ohmage_data|
          ohamge_events_date << ohmage_data.header.creation_date_time[0..9]
          ohamge_events_date = ohamge_events_date.uniq
        end
      end

      ohamge_events_date.each do |ohmage_date|
        ohmage_events_array << {
          title: 'ohmage',
          start: ohmage_date,
          className: 'event_style'
        }
      end
      return ohmage_events_array.to_json
    end
    ```
    
    <p>In views/users/_calendar_view.html.erb, the ohmage array function is called and result is stored in the data-attribute for the #ohmage_events_array div. And the path for one day ohmage data also get stored into the data-url attribute of the #one_day_ohmage_data div.</p>

    ```
      <div id="one_day_ohmage_data" data-url="/admin/users/<%= @user.id %>/ohmage_data_points?date="></div>
      <div id="ohmage_events_array" data-attribute="<%= @user.calendar_ohmage_events_array(current_admin_user.id) %>"></div>
    ```
    
    <p>Then in the assets/fullcalendar_implementation.js, the ohmage_events_array get called and rendered on the calendar as events.</p>
    
    ```
    var one_day_ohmage_data = $('#one_day_ohmage_data').data('url');
    var ohmage_events_array = $('#ohmage_events_array').data('attribute');

    $('#calendar').fullCalendar({
        header: {
            right: 'prev,next,today,year,month',
            left: 'title'
        },
        defaultView: 'year',
        yearColumns: 2,
        selectable: true,
        timezone: "UTC",
        editable: true,
        unselectAuto: false,
        aspectRatio: 1.65,
        events: ohmage_events_array,
        ......
    ```
    
    <p>In controllers/ohmage_data_points_controller.rb, the functions are called and the paths are created for the one day ohmage data.</p>

    ```
    class Admin::OhmageDataPointsController < ApplicationController
      def index
        @user = User.find(params[:user_id])
        respond_to do |format|
          format.csv {render text: @user.ohmage_data_csv(current_admin_user.id)}
          format.html {render partial: 'show', method: @user.calendar_ohmage_events_array(current_admin_user.id)}
        end
      end
    end
    ```
    
    <p>In the views/admin/ohmage_data_points/_show.html.haml, the data for that specific date are rendered.</p>
    <p>Related files</p>
    <p>models/user.rb</p>
    <p>controllers/pam_data_points_controller.rb</p>
    <p>controllers/ohmage_data_points_controller.rb</p>
    <p>controllers/fitbit_data_points_cntroller.rb</p>
    <p>views/admin/pam_data_points/_show.html.haml</p>
    <p>views/admin/ohmage_data_points/_show.html.haml</p>
    <p>views/admin/fitbi_data_points/_show.html.haml</p>
    <li>Image download</li>
    <p>The dashboard used <a href="https://github.com/ahoward/mongoid-grid%2Dfs">mongoid-grid%2Dfs</a>, a pure Mongoid/Moped implementation of the MongoDB GridFS specification. In controllers/admin/images_controller.rb, the meta data of images will be directly pulled out from the mongodb and send the files as download.</p>
    
    ```
    class Admin::ImagesController < ApplicationController
      def show
        image = Mongoid::GridFs.get(params[:id])
        filename = image.filename
        csv_filename = image.metadata["media_id"]
        send_data image.data, filename: csv_filename, type: image.content_type, disposition: 'attachment'
      end
    end
    ```
    
    <p>In a survey datapoint that contains images, the name of the image file is the metadata.media_id field of the actual image file in the fs.files. In views/admin/ohmage_data_points/_show.html.haml, it finds the id of the image file by searching it with its metadata.media_id attribute from the survery datapoint. After that, it assigns the path of the images as hyperlink to the filename of the image on the one day ohmage data.</p>
    
    ```
    - def get_survey_image_download_link(filename)
      -  @image = SurveyImage.where('metadata.media_id'=> filename)
      -  if !@image.blank?
        -  @image_id = @image.first.id
        -  @download_link = "/admin/images/" + @image_id
      - else
        - @link = ''
    ```
    
    <li>Annotation</li>
    <p>annotation_controller.rb</p>
  </ul>
  <li>CSV File Download</li>
  <p></p>
</ul>
<h5>Data Integration</h5>
<ul>
  <li>Mongodb</li>
  <p>config/mongoid.yml</p>
  <p>
    In order to have a copy of the attributes in the mongodb, you need to set each attribute as a class under models folder to establish the relationship but you don't need to run migration yourself. </p>

  <p>PamUser model is refered to the endUser collection in the omh mongodb. PamDataPoint is refered to the dataPoint collection. Image model is refered to the fs.files collection. The fs.chucks collection stores the meta data of the images in fs.files collection. See <a href="http://guides.rubyonrails.org/association_basics.html">here</a> for information about the relation.
  </p>
  <p>For example</p>
  <p>The format of the endUser data in the mongodb</p>
  
          ```
          { "_id" : "test_user_1", "_class" : "org.openmhealth.dsu.domain.EndUser", "password_hash" : "$2a$10$tI8FQMDq8CbJVgVvf4h3euauAtr.CBzk4XujD4ueFpSe8inODQNwu", "email_address" : { "address" : "useremail@gmail.com" }, "registration_timestamp" : "2015-12-16T20:39:57.415Z" }
          ```
          
  <p>In the model/pam_user.rb</p>
  
  ```
  class PamUser
    #### Mongodb attributes
    include Mongoid::Document
    store_in collection: 'endUser', database: 'omh'

    field :_id, type: Object

    #### Establish the relationship
    has_many :pam_data_points

    embeds_one :email_address
  end
  ```
  
  <p>Since it embeds email_address field, you need to create a model for the email_address field. In email_address.rb</p>
  
  ```
  class EmailAddress
    #### Mongodb attributes
    include Mongoid::Document
    store_in collection: 'endUser', database: 'omh'

    field :address, type: String
    embedded_in :pam_user, :inverse_of => :email_address
  end
  ```
  
  <li>Postgres</li>
  <p>
    Active Admin is built in with Postgres and you need to run migration to create new tables. Run "rails g active_record:migration xxxxxxxx" for adding new migration and then run "rake db:migrate" after you have edited the migration file. All th migration are located in db/migrate.</p>
  <p>
    When you establish a relation, you need to establish the relation in the migration and also in the models. Please see the following relation.
  </p>
  <p>
    Admin User has many to many relation with Study through study%2Downer table. Study has many to many relation with User(Participant) through study%2Dparticipant table. Survey has many to many relation with Study through s%2Dsurvey%2Dtable. Data Stream has many to many relation with Study through s%2Ddata%2Dstream table. Organization has a many to many relation with Study through organization%2Dstudy table and with Admin User through organization%2Downer table. The relation is important because researcher can only see the participants and data belong to their studies and it could help to give access to researchers.
  </p>
  <p>
    See example for the relation between Admin User and Study.
  </p>
  <p>In config/migrate/20150124183817_create_study_owners.rb</p>
  
  ```
  class CreateStudyOwners < ActiveRecord::Migration
    def change
      create_table :study_owners do |t|
        ##### Establish relation here
        t.belongs_to :admin_user, index: true
        t.belongs_to :study, index: true

        t.timestamps
      end
    end
  end
  ```
  
  <p>In models/admin_user.rb</p>
  
  ```
  class AdminUser < ActiveRecord::Base
    has_many :study_owners
    has_many :studies, through: :study_owners
  end
  ```
  
  <p>In models/study.rb</p>
  
  ```
  class Study < ActiveRecord::Base
    has_many :admin_users, through: :study_owners
    has_many :study_owners
  end
  ```
  
  <p>In models/study_owner.rb</p>
  
  ```
  class StudyOwner < ActiveRecord::Base
    belongs_to :admin_user
    belongs_to :study

    validates_presence_of :admin_user
    validates_presence_of :study
  end
  ```
  
</ul>


