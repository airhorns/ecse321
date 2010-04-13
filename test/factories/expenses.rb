Factory.define :expense do |e|
  e.cost 10
  e.sequence(:name) {|n| "Expense ##{n}" }
  e.description "Something that cost money."
  e.association :user
  e.association :task
end

Factory.define :pending do |e|
  e.cost 10
  e.sequence(:name) {|n| "Expense ##{n}" }
  e.description "Something that cost money."
  e.association :user
  e.association :task
  e.state = Expense::Pending
end

Factory.define :approved do |e|
  e.cost 10
  e.sequence(:name) {|n| "Expense ##{n}" }
  e.description "Something that cost money."
  e.association :user
  e.association :task
  e.state = Expense::Approved
end

Factory.define :rejected do |e|
  e.cost 10
  e.sequence(:name) {|n| "Expense ##{n}" }
  e.description "Something that cost money."
  e.association :user
  e.association :task
  e.state = Expense::Rejected
end

Factory.define :invoiced do |e|
  e.cost 10
  e.sequence(:name) {|n| "Expense ##{n}" }
  e.description "Something that cost money."
  e.association :user
  e.association :task
  e.state = Expense::Invoiced
end
