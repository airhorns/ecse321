Factory.define :hour_report do |e|
  e.hours 10
  e.sequence(:name) {|n| "Hour Report ##{n}" }
  e.description "Something that cost money."
  e.association :user
  e.association :task
end

Factory.define :pending do |e|
  e.cost 10
  e.sequence(:name) {|n| "Hour Report ##{n}" }
  e.description "Something that cost money."
  e.association :user
  e.association :task
  e.state = HourReport::Pending
end

Factory.define :approved do |e|
  e.cost 10
  e.sequence(:name) {|n| "Hour Report ##{n}" }
  e.description "Something that cost money."
  e.association :user
  e.association :task
  e.state = HourReport::Approved
end

Factory.define :rejected do |e|
  e.cost 10
  e.sequence(:name) {|n| "Hour Report ##{n}" }
  e.description "Something that cost money."
  e.association :user
  e.association :task
  e.state = HourReport::Rejected
end

Factory.define :invoiced do |e|
  e.cost 10
  e.sequence(:name) {|n| "Hour Report ##{n}" }
  e.description "Something that cost money."
  e.association :user
  e.association :task
  e.state = HourReport::Invoiced
end
