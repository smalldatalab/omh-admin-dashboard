<<<<<<< HEAD
=======
# SDL ADMIN DASHBOARD - Manage Users' Data

## Overview

The admin dashboard is a web-based interface that enables the researchers (or clinicians) to setup, monitor, and retrieve data from authorized participants of their studies using a specified set of mobile health applications. It is one part of [ohmage-omh](http://ohmage-omh.smalldata.io/) project, which is an open-source, open-architecture, mobile health platform intended for rapid prototyping and piloting of mobile health applications. The dashboard is integrated with Mobilty, ohmage, PAM, Moves and Fitbit apps and available for CSV and image data donwload.

## Background

SDL Admin Dashboard is a Ruby on Rails project. It uses [Active Admin](http://activeadmin.info/), a Ruby on Rails plugin for generating administration style interfaces. It intergates with ohmage-omh MongoDB using <a href="https://docs.mongodb.org/ecosystem/tutorial/ruby-mongoid-tutorial/">Mongoid</a>, a Ruby MongoDB Driver. You can edit config/mongoid.yml for changing database information. See Gemfile for a complete list of gems used in the project.

#### Built-in Active Admin Functions

Active Admin brought with the set of framework including controller, models, views and migration for Admin USer and Users. Please see Active Admin main page for more information.

#### Later Added On Functions (Customized)
##### Feature in Admin User Panel
> Authorization

Edit models/admin_authoriations.rb for Admin User type's access. See [here](http://activeadmin.info/docs/13-authorization-adapter.html) for more information. If you want to edit the content of each individual panel, edit individual file under app/admin.

>  Emails Sending

It uses [Mandrill](https://www.mandrill.com/) for sending emails. You need to create a username and password. Also, you can follow the instructions on Mandrill to set up a domain name for your email sender. Please edit `config/application.rb`.

```Ruby
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

##### Feature in Participant Panel

> Calendar

The calendar is built with [FullCalendar](http://fullcalendar.io/), an open source JavaScript jQuery plugin for a full-sized, drag & drop event calendar. The codebase is in `assets/fullcalendar_implementation.js`.

> Graph

The graph is built with [D3](http://d3js.org/), a JavaScript library for visualizing data with HTML, SVG, and CSS. It renders three aspects of the daily summarized Mobility data, "Time Not At Home", "Active Time" and "Max Speed". See `assets/fullcalendar_implementation.js` for more information.

> One Day Data

One day data array of all three data streams, PAM, ohmage ang Fitbit are handled by in the models/user.rb and the arrays are rendered as events on the calendar of individual partcipant. The event also has a hyperlink that will direct to a page that shows the data for that date. 
  
Take ohmage survey data as an example, in `models/user.rb` the ohmage data for one specific participant get collected.

```Ruby
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
Then the following function turns the data in the JSON format that could be read by the fullcalendar JavaScript plugin.

```Ruby
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

In `views/users/_calendar_view.html.erb`, the ohmage array function is called and result is stored in the data-attribute for the #ohmage_events_array div. And the path for one day ohmage data also get stored into the data-url attribute of the #one_day_ohmage_data div.

 ```HTML
<div id="one_day_ohmage_data" data-url="/admin/users/<%= @user.id %>/ohmage_data_points?date="></div>
<div id="ohmage_events_array" data-attribute="<%= @user.calendar_ohmage_events_array(current_admin_user.id) %>"></div>
```

Then in the `assets/fullcalendar_implementation.js`, the ohmage_events_array get called and rendered on the calendar as events.

```JavaScript
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

In `controllers/ohmage_data_points_controller.rb`, the functions are called and the paths are created for the one day ohmage data.

```Ruby
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

In the `views/admin/ohmage_data_points/_show.html.haml`, the data for that specific date are rendered.

Related files

* `models/user.rb`
* `controllers/pam_data_points_controller.rb`
* `controllers/ohmage_data_points_controller.rb`
* `controllers/fitbit_data_points_cntroller.rb`
* `views/admin/pam_data_points/_show.html.haml`
* `views/admin/ohmage_data_points/_show.html.haml`
* `views/admin/fitbi_data_points/_show.html.haml`
  
> Image download

The dashboard used [mongoid-grid_fs](https://github.com/ahoward/mongoid-grid_fs), a pure Mongoid/Moped implementation of the MongoDB GridFS specification. In `controllers/admin/images_controller.rb`, the meta data of images will be directly pulled out from the mongodb and send the files as download.

```Ruby
class Admin::ImagesController < ApplicationController
  def show
    image = Mongoid::GridFs.get(params[:id])
    filename = image.filename
    csv_filename = image.metadata["media_id"]
    send_data image.data, filename: csv_filename, type: image.content_type, disposition: 'attachment'
  end
end
```

In a survey datapoint that contains images, the name of the image file is the metadata.media_id field of the actual image file in the fs.files collection. In `views/admin/ohmage_data_points/_show.html.haml`, it finds the id of the image file by searching it with its metadata.media_id attribute from the survery datapoint. After that, it assigns the path of the images as hyperlink to the filename of the image on the one day ohmage data.

``` Ruby
def get_survey_image_download_link(filename)
  @image = SurveyImage.where('metadata.media_id'=> filename)
  if !@image.blank?
    @image_id = @image.first.id
    @download_link = "/admin/images/" + @image_id
  else
    @link = ''
```
> Annotation

Fullcalendar js plugin enables you click on any date on the calendar and that function is edited in   `fullcalendar_implementation.js` as below. 

```JavaScript
select: function(start, end) {
         document.getElementById("eventDate").setAttribute('value', moment(end['_d']).format('YYYY-MM-DD'));
         document.getElementById("eventButton").click();
     }
```
A #eventButton div in the `views/_calendar_view.html.haml` is a Bootstrap modal that will get triggered when a date is selected on the calendar. 

```HTML
<button id="eventButton" type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#annotationInput" style="display: none;">Open Modal</button>

 <div class="modal fade" id="annotationInput" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
           <div class="modal-header">
               <button type="button" class="close" data-dismiss="modal">
                   &times;
               </button>
               <h4>Annotation:</h4>
           </div>
           <%= form_for :annotation, url: admin_user_annotations_path(@user.id) do |f| %>
               <div class="modal-body">
                   <p>
                      <%= f.label 'Note: ' %>
                      <%= f.text_field :title, id: 'eventTitle' %>
                   </p>
                   <br>
                   <p>
                       <%= f.label 'Date: ' %>
                       <%= f.text_field :start, id: 'eventDate', value: ''%>
                   </p>
               </div>
               <div class="modal-footer">
                   <%= f.submit %>
               </div>
          <% end %>
       </div>
   </div>
 </div>
```

The creation of the annotations is handled in the `controllers/admin/annotation_controller.rb` and the has many relation between User and Annotation are handled in `models/annotation.rb` and `models/user.rb`. 

> CSV File Download

The buttons for download are added in `app/admin/user.rb` as below. Take Fitbit data as an example.  

``` Ruby
action_item :only => :show do
   link_to 'Fitbit Data csv File', admin_user_fitbit_data_points_path(user, format: 'csv')
end
```

Then in `controllers/admin/fitbit_data_points_controller.rb`, the path for the CSV download is established. 

```Ruby
class Admin::FitbitDataPointsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    respond_to do |format|
      format.csv {render text: @user.fitbit_data_csv }
      format.html {render partial: 'show', method: @user.calendar_fitbit_events_array}
    end
  end
end
```

The fitbit_data_csv function is located in `models/user.rb` 

```Ruby
def fitbit_data_csv
   CSV.generate do |csv|
     csv << [
              'date',
              'steps'
            ]
     if all_fitbit_data_points.nil?
       return nil
     else
       all_fitbit_data_points.each do |data_point|
       csv << [
                 data_point.header.creation_date_time,
                 data_point.body.step_count
        ]
       end
     end
   end
end
```

CSV download function of ohmage survey data is a bit more complex because it uses a horizontal data input method in order to capture the surveys with different number of questions. It requires three functions as below. 

```Ruby
def get_all_survey_question_keys(admin_user_id)
   ohmage_data_points = all_ohmage_data_points(admin_user_id)
   if @user_record.nil?
      return nil
   else
      if ohmage_data_points.nil?
        return nil
      else
        survey_keys = [
                      'source_name',
                      'creation_date_time',
                      'survey_namespace',
                      'survey_name',
                      'survey_version'
                      ]
        ohmage_data_points.each do |a|
          if a.body.data
            a.body.data.attributes.each do |key, value|
              survey_keys.push(key) unless survey_keys.include? key
            end
          else
             a.body.attributes.each do |key, value|
              survey_keys.push(key) unless survey_keys.include? key
            end
          end
        end
        return survey_keys
      end
   end
end

def get_all_survey_question_values(survey_keys, data_point)
   survey_values = [
                    data_point.header.acquisition_provenance.source_name,
                    data_point.header.creation_date_time,
                    data_point.header.schema_id.namespace,
                    data_point.header.schema_id.name,
                    data_point.header.schema_id.version.major.to_s + '.' + data_point.header.schema_id.version.minor.to_s
                    ]
   fixed_survey_values_count = survey_values.length
   if data_point.body.data
      survey_keys.each_with_index do |key, index|
        if index >= fixed_survey_values_count
          survey_values << data_point.body.data[key] ? data_point.body.data[key] : nil
        end
      end
    else
      survey_keys.each_with_index do |key, index|
        if index >= fixed_survey_values_count
          survey_values << data_point.body[key] ? data_point.body[key] : nil
       end
     end
   end
   return survey_values
 end
 
def ohmage_data_csv(admin_user_id=nil)
   CSV.generate do |csv|
     keys = get_all_survey_question_keys(admin_user_id)
      if keys
        csv << keys
        data_points = all_ohmage_data_points(admin_user_id)
       if data_points.nil?
          return nil
       else
         data_points.each do |data_point|
            csv << get_all_survey_question_values(keys, data_point) if data_point.body.data || data_point.body
         end
       end
     end
   end
end
```

##### Data Integration

> Mongodb

Please see `config/mongoid.yml` for configuration to connect to the mongodb. 

In order to have a copy of the attributes in the mongodb, you need to set each attribute as a class under models folder to establish the relationship but you don't need to run migration yourself.

PamUser model is refered to the endUser collection in the omh mongodb. PamDataPoint is refered to the dataPoint collection. Image model is refered to the fs.files collection. The fs.chucks collection stores the meta data of the images in fs.files collection. See [here](http://guides.rubyonrails.org/association_basics.html) for information about the relation. Please see the example below.

The format of the endUser data in the mongodb

```json
{ "_id" : "test_user_1", "_class" : "org.openmhealth.dsu.domain.EndUser", "password_hash" : "$2a$10$tI8FQMDq8CbJVgVvf4h3euauAtr.CBzk4XujD4ueFpSe8inODQNwu", "email_address" : { "address" : "useremail@gmail.com" }, "registration_timestamp" : "2015-12-16T20:39:57.415Z" }
```

In the `model/pam_user.rb`

```ruby
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

Since it embeds email_address field, you need to create a model for the email_address field. In `email_address.rb`

```Ruby
class EmailAddress
  #### Mongodb attributes
  include Mongoid::Document
  store_in collection: 'endUser', database: 'omh'

  field :address, type: String
  embedded_in :pam_user, :inverse_of => :email_address
end
```

> Postgres

Active Admin is built in with Postgres and you need to run migration to create new tables. Run "rails g active_record:migration xxxxxxxx" for adding new migration and then run 'rake db:migrate' after you have edited the migration file. All th migration are located in db/migrate.

When you establish a relation, you need to establish the relation in the migration and also in the models. Please see the following relation.

Admin User has many to many relation with Study through study_owner table. Study has many to many relation with User(Participant) through study_participant table. Survey has many to many relation with Study through s_survey table. Data Stream has many to many relation with Study through s_data_stream table. Organization has a many to many relation with Study through organization_study table and with Admin User through organization_owner table. The relation is important because researcher can only see the participants and data belong to their studies and it could help to give access to researchers.

See example for the relation between Admin User and Study.

In `config/migrate/20150124183817_create_study_owners.rb`

```Ruby
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

In `models/admin_user.rb`

```Ruby
class AdminUser < ActiveRecord::Base
has_many :study_owners
has_many :studies, through: :study_owners
end

```

In `models/study.rb`

```Ruby
class Study < ActiveRecord::Base
  has_many :admin_users, through: :study_owners
  has_many :study_owners
end
```

In `models/study_owner.rb`

```Ruby
class StudyOwner < ActiveRecord::Base
  belongs_to :admin_user
  belongs_to :study

  validates_presence_of :admin_user
  validates_presence_of :study
end
```
>>>>>>> 7be5ec6117ff7e5bbef444e74f3a4a394392019c
