Factory.define :contact do |b|
  b.name "Joe Blow"
  b.telephone "555 555 5555"
  b.association :business, :factory => :business
  b.association :address, :factory => :address
end