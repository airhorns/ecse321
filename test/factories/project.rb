Factory.define :project do |p|
  p.name "A Beautiful Website"
  p.notes "Depicts everything wonderful in the world"
  p.due_date Time.now + 10.days
  p.association :business, :factory => :business
  p.association :user, :factory => :user
end