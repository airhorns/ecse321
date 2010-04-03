# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

User.create!(:email=>"admin@example.com",
:active=> true,
:first_name=>"Admin", 
:last_name=>"Istrator", 
:hourly_rate => 10, 
:telephone => "5555555555", 
:password => "apple123", 
:password_confirmation => "apple123", 
:role => "admin")

User.create!(:email=>"joe@example.com", 
:active=> true,
:first_name=>"Joe", 
:last_name=>"Employee", 
:hourly_rate => 10, 
:telephone => "5555555555", 
:password => "apple123", 
:password_confirmation => "apple123", 
:role => "employee")