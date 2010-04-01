Factory.define :user do |u|
  u.email "employee@email.com"
  u.password "apple123"
  u.password_confirmation "apple123"
  u.after_build { |user| user.__initialize_canable_role}
end

Factory.define :admin, :parent => :user do |u|
  u.email "admin@email.com"
  u.role :admin
end

Factory.define :manager, :parent => :user do |u|
  u.email "manager@email.com"
  u.role :manager
end

