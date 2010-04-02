Factory.define :user do |u|
  u.email "employee@email.com"
  u.password "apple123"
  u.password_confirmation "apple123"
end

# needed for the example with all three types of users trying to create a new user
Factory.define :new_user, :parent => :user do |u|
  u.email "new_employee@email.com"
end

Factory.define :admin, :parent => :user do |u|
  u.email "admin@email.com"
  u.role :admin
end

Factory.define :manager, :parent => :user do |u|
  u.email "manager@email.com"
  u.role :manager
end

