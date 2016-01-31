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
