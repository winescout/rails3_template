def rvm_run(command, config = {})
  run "rvm ruby-1.9.2@#{app_name} #{command}", config
end

def install_file(local_path, opts = {})
  run "mkdir -p tmp/templates/#{File.dirname(local_path)}"
  run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/#{local_path}' -O tmp/templates/#{local_path}"
  run "ruby -rerb  -e \"app_name = '#{app_name.camelize}'; puts ERB.new(File.read(\\\"tmp/templates/#{local_path}\\\")).result(binding)\" > #{local_path}"
end

run "rm -Rf .gitignore README public/index.html public/javascripts/* test app/views/layouts/*"


run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/Gemfile' -O Gemfile"

run "rvm --create --rvmrc use ruby-1.9.2@#{app_name}" 
rvm_run "gem install bundler"
rvm_run "-S bundle install"


application  <<-GENERATORS
config.generators do |g|
  g.template_engine :haml
  g.test_framework  :rspec, :fixture => true, :views => false
  g.integration_tool :rspec, :fixture => true, :views => true
  g.fixture_replacement :factory_girl, :dir => "spec/support/factories"
end
GENERATORS

rvm_run "exec rails g rspec:install"
rvm_run "exec rails g cucumber:install --webrat --rspec --spork"
rvm_run "exec rails g pickle --path --email"
rvm_run "exec rails g friendly_id"
rvm_run "exec rails g formtastic:install"
rvm_run "exec rails g devise:install"
rvm_run "exec rails g devise User"
rvm_run "exec rails g devise Admin"

run "compass init --using blueprint --app rails --css-dir public/stylesheets"
append_file "config/compass.rb", "require 'lemonade'"

run "rm public/stylesheets/*"

#Welcome controller
rvm_run "exec rails g controller Welcome"
run "wget --no-check-certificate 'https://github.com/winescout/rails_3_template/raw/master/app/views/welcome/index.html.haml' -O app/views/welcome/index.html.haml"

#Homepage controller
rvm_run "exec rails controller Homepage"
run "wget --no-check-certificate 'https://github.com/winescout/rails_3_template/raw/master/app/views/homepage/index.html.haml' -O app/views/homepage/index.html.haml"

#User customizations
run "mkdir -p app/views/users"
run "wget --no-check-certificate 'https://github.com/winescout/rails_3_template/raw/master/app/views/users/new.html.haml' -O app/views/users/new.html.haml"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/app/controllers/users_controller.rb' -O app/controllers/users_controller.rb"

#Password customizations
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/app/controllers/passwords_controller.rb' -O app/controllers/passwords_controller.rb"
run "mkdir -p app/views/passwords"
run "wget --no-check-certificate 'https://github.com/winescout/rails_3_template/raw/master/app/views/passwords/new.html.haml' -O app/views/passwords/new.html.haml"
run "wget --no-check-certificate 'https://github.com/winescout/rails_3_template/raw/master/app/views/passwords/edit.html.haml' -O app/views/passwords/exit.htlm.haml"

#Session customizations
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/app/controllers/sessions_controller.rb' -O app/controllers/sessions_controller.rb"
run "mkdir -p app/views/sessions"
run "wget --no-check-certificate 'https://github.com/winescout/rails_3_template/raw/master/app/views/sessions/new.html.haml' -O app/views/sessions/new.htlm.haml"


run "wget --no-check-certificate 'https://github.com/rails/jquery-ujs/raw/master/src/rails.js' -O public/javascripts/rails.js"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/gitignore' -O .gitignore"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/screen.scss' -O app/stylesheets/screen.scss"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/print.scss' -O app/stylesheets/print.scss"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/application.html.haml' -O app/views/layouts/application.html.haml"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/factory_girl.rb' -O features/support/factory_girl.rb"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/devise_steps.rb' -O features/step_definitions/devise_steps.rb"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/remarkable.rb' -O spec/support/remarkable.rb"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/users.rb' -O spec/support/factories/users.rb"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/build.rake' -O lib/tasks/build.rake"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/bootstrap.rake' -O lib/tasks/bootstrap.rake"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/build.sh' -O build.sh"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/overlay.png' -O public/images/overlay.png"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/htaccess' -O public/.htaccess"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/grid.png' -O public/images/grid.png"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/app/views/layouts/anonymous.html.haml' -O app/views/layouts/anonymous.html.haml"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/app/controllers/application_controller.rb' -O app/controllers/application_controller.rb"

run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/public/javascripts/jquery-ui.min.js' -O public/javascripts/jquery-ui.min.js"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/public/javascripts/jasmine-jquery-1.2.0.js' -O public/javascripts/jasmine-jquery-1.2.0.js"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/public/javascripts/jquery.min.js' -O public/javascripts/jquery.min.js"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/public/javascripts/navigation.coffee' -O public/javascripts/navigation.coffee"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/public/javascripts/navigation.js' -O public/javascripts/navigation.js"

#stylesheets
run "mkdir -p app/stylesheets"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/app/stylesheets/anonymous.scss' -O app/stylesheets/anonymous.scss"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/app/stylesheets/navigation.scss' -O app/stylesheets/navigation.scss"

run "mkdir -p public/stylesheets/jquery-ui/ui-lightness"
run "git clone https://github.com/jquery/jquery-ui.git tmp/jquery-ui"
run "mv tmp/jquery-ui/themes/base/images public/stylesheets/jquery-ui/ui-lightness/images" 
run "wget 'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.10/themes/ui-lightness/jquery-ui.css' -O public/stylesheets/jquery-ui/ui-lightness/jquery-ui.1.8.10.css"

#controllers
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/app/controllers/homepage_controller.rb' -O app/controllers/homepage_controller.rb"

# replacing routes
install_file "config/routes.rb"

run "mkdir -p app/coffeescripts spec/javascripts spec/javascripts/templates"
run "chmod u+x build.sh"

#git :init
#git :add => '.'
#git :add => 'public/javascripts/rails.js --force'
#git :commit => '-am "Initial commit"'

puts "SUCCESS!"



