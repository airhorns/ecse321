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

Business.create!(:name=>"First business",
:website=>"lalala.com",
:telephone=> 4445556666,
:fax=>1112223333,
:email=>"cool@t.com",
:notes=>"et voila!" )

Project.create!(:name=>"Treezers",
:notes=>"we make nice green trees",
:due_date=>"2010-04-06 00:00:00 UTC"
:user_id=>1,
:business_id=>1)
