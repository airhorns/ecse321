Factory.define :user_session do |u|
  u.association :user, :factory => :admin
end