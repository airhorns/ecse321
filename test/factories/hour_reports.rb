Factory.define :hour_report do |e|
  e.hours 10
  e.sequence(:name) {|n| "Hour Report ##{n}" }
  e.description "Something that cost money."
  e.association :user
  e.association :task
end

Factory.define :pending_hour_report, :parent => :hour_report do |e|
  e.state HourReport::Pending
end

Factory.define :approved_hour_report, :parent => :hour_report do |e|
  e.state HourReport::Approved
end

Factory.define :rejected_hour_report, :parent => :hour_report do |e|
  e.state HourReport::Rejected
end

Factory.define :invoiced_hour_report, :parent => :hour_report do |e|
  e.state HourReport::Invoiced
end
