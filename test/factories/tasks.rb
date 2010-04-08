Factory.define :task do |f|
  f.sequence(:name) {|n| "Task ##{n}" }
  f.description "Something needing to be accomplished."
  f.association :project
end