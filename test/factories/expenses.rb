Factory.define :expense do |e|
  e.cost 10
  e.sequence(:name) {|n| "Expense ##{n}" }
  e.description "Something that cost money."
  e.association :user
  e.association :task
end

Factory.define :pending_expense, :parent => :expense do |e|
  e.state Expense::Pending
end

Factory.define :approved_expense, :parent => :expense do |e|
  e.state Expense::Approved
end

Factory.define :rejected_expense, :parent => :expense do |e|
  e.state Expense::Rejected
end

Factory.define :invoiced_expense, :parent => :expense do |e|
  e.state Expense::Invoiced
end
