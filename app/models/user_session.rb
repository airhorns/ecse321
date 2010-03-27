# The +UserSession+ class represents one instance of someone successfully authenticating and logging in to the system.
# It holds all the information about the time and nature of the login and represents the connection for the duration
# of the session. Extends +Authlogic::Session::Base+.
# @author Harry Brundage
class UserSession < Authlogic::Session::Base
	# All standard functionality is provided by +Authlogic+
end
