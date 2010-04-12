Factory.define :invoice do |i|
  i.start_date Time.now - 30.days
  i.end_date Time.now
  i.association :project
end