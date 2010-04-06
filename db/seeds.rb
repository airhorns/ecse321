# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

@admin = User.create!(:email=>"admin@example.com",
:active => true,
:first_name =>"Admin", 
:last_name =>"Istrator", 
:hourly_rate => 10, 
:telephone => "5555555555", 
:password => "apple123", 
:password_confirmation => "apple123", 
:role => "admin")

@joe = User.create!(:email=>"joe@example.com", 
:active => true,
:first_name =>"Joe", 
:last_name =>"Employee", 
:hourly_rate => 10, 
:telephone => "5555555555", 
:password => "apple123", 
:password_confirmation => "apple123", 
:role => "employee")

@employees = [].push(@joe)

@mary = User.create!(:email=>"mary@example.com", 
:active=> true,
:first_name=>"Mary", 
:last_name=>"Manager", 
:hourly_rate => 15, 
:telephone => "5555555555", 
:password => "apple123", 
:password_confirmation => "apple123", 
:role => "manager")

@mona = User.create!(:email=>"mona@example.com", 
:active=> true,
:first_name=>"Mona", 
:last_name=>"Manager", 
:hourly_rate => 15, 
:telephone => "5555555555", 
:password => "apple123", 
:password_confirmation => "apple123", 
:role => "manager")

@margaret = User.create!(:email=>"margaret@example.com", 
:active=> true,
:first_name=>"Margaret", 
:last_name=>"Manager", 
:hourly_rate => 15, 
:telephone => "5555555555", 
:password => "apple123", 
:password_confirmation => "apple123", 
:role => "manager")

@managers = [@mary, @mona, @margaret]

["Edward", "Edtih", "Earl", "Edmund", "Edna"].each do |name|
  @employees << User.create!(:email=>"#{name}@example.com", 
  :active => true,
  :first_name =>name, 
  :last_name =>"Employee", 
  :hourly_rate => 10, 
  :telephone => "5555555555", 
  :password => "apple123", 
  :password_confirmation => "apple123", 
  :role => "employee")
end

@acme = Business.create!(:name=>"ACME Web Design",
:website => "http://www.google.com/",
:telephone => 4445556666,
:fax => 1112223333,
:email => "cool@gmail.com",
:notes => "et voila!" )

@project1 = Project.create!(:name=>"A Beautful Website",
:notes => "A nice green website.",
:due_date => "2010-04-06 00:00:00 UTC",
:user => @mary,
:business => @acme,
:users => @employees[2..-1])

Task.create!([{:name => "Layout and CSS", :description => "Visual themeing of the website", :project => @project1}, 
              {:name => "MVC Code", :description => "Rails work.", :project => @project1},
              {:name => "Testing", :description => "Quality Assurance", :project => @project1}])
                                
@project2 = Project.create!(:name=>"Wear Your Helmet Brochure",
:notes => "Ride safe!",
:due_date => "2010-04-06 00:00:00 UTC",
:user => @mary,
:business => @acme,
:users => @employees[0..5])

Task.create!([{:name => "Layout", :description => "Visual themeing and graphic design", :project => @project2}, 
              {:name => "Copy writing", :description => "Words and words", :project => @project2},
              {:name => "Printing", :description => "In volume", :project => @project2}])

@employees.each do |user|
  [@project1, @project2].each do |project|
    rand(6).times do 
      Expense.create!(:name => "Dinner with client.", 
                      :description => "An important meal where important things were discussed.",
                      :user => user,
                      :cost => rand(10000)/2, 
                      :task => project.tasks[rand(project.tasks.length-1)]
                    )
    end
    rand(30).times do 
      HourReport.create!(:description => "An important meal where important things were discussed.",
                         :date => Time.now - rand(5).days - rand(1000).minutes,
                         :hours => rand(10)+1,
                         :user => user,
                         :cost => rand(10000)/2, 
                         :task => project.tasks[rand(project.tasks.length-1)]
                        )
    end
  end
end
