# SDL ADMIN DASHBOARD - Manage Users' Data

## Overview

The admin dashboard is a web-based interface that enables the researchers (or clinicians) to setup, monitor, and retrieve data from authorized participants of their studies using a specified set of mobile health applications. It is one part of [ohmage-omh](http://ohmage-omh.smalldata.io/) project, which is an open-source, open-architecture, mobile health platform intended for rapid prototyping and piloting of mobile health applications. The dashboard is integrated with Mobilty, ohmage, PAM, Moves and Fitbit apps and available for CSV and image data donwload.

## Background

SDL Admin Dashboard is a Ruby on Rails project. It uses [Active Admin](http://activeadmin.info/), a Ruby on Rails plugin for generating administration style interfaces. It intergates with ohmage-omh MongoDB using <a href="https://docs.mongodb.org/ecosystem/tutorial/ruby-mongoid-tutorial/">Mongoid</a>, a Ruby MongoDB Driver. You can edit config/mongoid.yml for changing database information. See Gemfile for a complete list of gems used in the project.

* Ruby on Rails
* Active Admin
* Mongodb
* Mongoid
* d3
* JavaScript
 
#### Built-in Active Admin Functions

Active Admin brought with the set of framework including controller, models, views and migration for Admin USer and Users. Please see Active Admin main page for more information.

#### Later Added On Functions (Customized)
##### Feature in Admin User Panel
Authorization

Edit models/admin_authoriations.rb for Admin User type's access. See [here](http://activeadmin.info/docs/13-authorization-adapter.html) for more information. If you want to edit the content of each individual panel, edit individual file under app/admin.

##### Emails Sending

It uses [Mandrill](https://www.mandrill.com/) for sending emails. You need to create a username and password. Also, you can follow the instructions on Mandrill to set up a domain name for your email sender. Please edit config/application.rb.

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

models/admin_user.rb

##### Feature in Participant Panel

Calendar
The calendar is built with [FullCalendar](http://fullcalendar.io/), an open source JavaScript jQuery plugin for a full-sized, drag & drop event calendar. The codebase is in assets/fullcalendar_implementation.js.

Graph

The graph is built with [D3](http://d3js.org/), a JavaScript library for visualizing data with HTML, SVG, and CSS. It renders three aspects of the daily summarized Mobility data, "Time Not At Home", "Active Time" and "Max Speed". See assets/fullcalendar_implementation.js for more information.

One Day Data

One day data array of all three data streams, PAM, ohmage ang Fitbit are handled by in the models/user.rb and the arrays are rendered as events on the calendar of individual partcipant. The event also has a hyperlink that will direct to a page that shows the data for that date. 
  
Take ohmage survey data as an example, in models/user.rb the ohmage data for one specific participant get collected.

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

In views/users/_calendar_view.html.erb, the ohmage array function is called and result is stored in the data-attribute for the #ohmage_events_array div. And the path for one day ohmage data also get stored into the data-url attribute of the #one_day_ohmage_data div.

 ```HTML
<div id="one_day_ohmage_data" data-url="/admin/users/<%= @user.id %>/ohmage_data_points?date="></div>
<div id="ohmage_events_array" data-attribute="<%= @user.calendar_ohmage_events_array(current_admin_user.id) %>"></div>
```

Then in the assets/fullcalendar_implementation.js, the ohmage_events_array get called and rendered on the calendar as events.

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

In controllers/ohmage_data_points_controller.rb, the functions are called and the paths are created for the one day ohmage data.


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

In the views/admin/ohmage_data_points/_show.html.haml, the data for that specific date are rendered.
Related files
* models/user.rb
* controllers/pam_data_points_controller.rb
* controllers/ohmage_data_points_controller.rb
* controllers/fitbit_data_points_cntroller.rb
* views/admin/pam_data_points/_show.html.haml
* views/admin/ohmage_data_points/_show.html.haml
* views/admin/fitbi_data_points/_show.html.haml
  
Image download

The dashboard used [mongoid-grid_fs](https://github.com/ahoward/mongoid-grid_fs), a pure Mongoid/Moped implementation of the MongoDB GridFS specification. In controllers/admin/images_controller.rb, the meta data of images will be directly pulled out from the mongodb and send the files as download.

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

In a survey datapoint that contains images, the name of the image file is the metadata.media_id field of the actual image file in the fs.files. In views/admin/ohmage_data_points/_show.html.haml, it finds the id of the image file by searching it with its metadata.media_id attribute from the survery datapoint. After that, it assigns the path of the images as hyperlink to the filename of the image on the one day ohmage data.

``` Ruby
def get_survey_image_download_link(filename)
  @image = SurveyImage.where('metadata.media_id'=> filename)
  if !@image.blank?
    @image_id = @image.first.id
    @download_link = "/admin/images/" + @image_id
  else
    @link = ''
```
