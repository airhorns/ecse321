module DashboardHelper
	def activity_message_for(object)
		case object.class.name

			when 'Business'
				"Business " + link_to( object.to_s, object ) + " was created."

			when 'Invoice'
				"Invoice " + link_to( '#'+object.id, object ) + " was created for " + link_to( object.business.to_s, object.business ) + "."
			
			when 'Project'
				"Project " + link_to( object.to_s, object ) + " was created for " + link_to( object.business.to_s, object.business ) + "."
			
			when 'User'
				link_to( object.full_name, object ) + " has joined the system."

			when 'Expense'
				'An expense for ' + link_to( object.name, object ) + ' has been added to ' + link_to( object.task.name, object.task ) + '.'
			
			when 'HourReport'
				'Hours for ' + link_to( object.name, object ) + ' have been added to ' + link_to( object.task.name, object.task ) + '.'
				
			when 'Task'
				'Task ' + link_to(object.name, object) + ' has been added to ' + link_to( object.project.name, object.project) + '.'
				
		end
	end
end
