Factory.define :user do |u|
  u.active true
  u.sequence(:email) {|n| "employee#{n}@example.com" }
  u.password "apple123"
  u.password_confirmation "apple123"
  u.first_name "Joe"
  u.last_name "Blow"
  u.telephone "5555555555"
  u.hourly_rate 10
end

# needed for the example with all three types of users trying to create a new user
Factory.define :new_user, :parent => :user do |u|
  u.email "new_employee@email.com"
end

Factory.define :admin, :parent => :user do |u|
  u.role :admin
end

Factory.define :manager, :parent => :user do |u|
  u.role :manager
end

