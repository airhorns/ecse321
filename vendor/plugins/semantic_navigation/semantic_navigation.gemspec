Gem::Specification.new do |s|
  s.name = 'semantic_navigation'
  s.version = '1.0'
  s.date = '2009-11-10'
  
  s.summary = "A menu builder for rails"
  s.description = "A cleaner, meaner and simpler navigation builder based on the semantic-menu by Daniel Haran."
  
  s.authors = ['Marty Zalega', 'Daniel Haran']
  s.email = 'evil.marty@gmail.com'
  s.homepage = 'http://github.com/evilmarty/semantic_navigation'
  
  s.has_rdoc = false
  s.rdoc_options = ['--main', 'README.rdoc']
  s.rdoc_options << '--inline-source' << '--charset=UTF-8'
  s.extra_rdoc_files = ['README.rdoc', 'MIT-LICENSE', 'CHANGELOG.rdoc']
  
  s.files = %w(CHANGELOG.rdoc MIT-LICENSE README.rdoc Rakefile init.rb install.rb lib/menu_helper.rb lib/semantic_menu.rb test/semantic_menu_test.rb tasts/semantic_menu_tasks.rake public/stylesheets/semantic-menu.css)
  s.test_files = %w(test/semantic_menu_test.rb)
end