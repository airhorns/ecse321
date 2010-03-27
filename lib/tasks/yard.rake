require 'yard'
# Delete the old rails doc:app task that used RDOC
Rake.application.instance_variable_get('@tasks').delete('doc:app')

#Add the new Rake YARD task, name it :app to preserve the heirarchy.
namespace :doc do
YARD::Rake::YardocTask.new(:app) do |t|
  t.files   = ['app/**/*.rb']   # optional
  t.options = ['--output-dir=doc/app', '--private'] # optional
end
end