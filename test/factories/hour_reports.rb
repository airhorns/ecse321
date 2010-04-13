Factory.define :hour_report do |e|
  e.hours 10
  e.sequence(:name) {|n| "Hour Report ##{n}" }
  e.description "Something that cost money."
  e.association :user
  e.association :task
end