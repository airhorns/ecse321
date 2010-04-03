Factory.define :business do |b|
  b.name "ACME Web Design"
  b.telephone "555 555 5555"
  b.association :address, :factory => :address
end