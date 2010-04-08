Factory.define :expense do |e|
  e.cost 10
  e.sequence(:name) {|n| "Expense ##{n}" }
  e.description "Something that cost money."
  e.association :user
  e.association :task
end