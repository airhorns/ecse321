# The +User+ class represents a physical person's account in the system. A person must have a 
# representation as a +User+ record to be able to interact with the system. Users can only be
# created by administrators.
# @author Harry Brundage
class User < ActiveRecord::Base
  acts_as_authentic do |c|
    # for available options see documentation in: Authlogic::ActsAsAuthentic
  end
end
