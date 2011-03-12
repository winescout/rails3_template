def rvm_run(command, config = {})
  run "rvm ruby-1.9.2@#{app_name} #{command}", config
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

generate "rspec:install"
generate "cucumber:install --webrat --rspec --spork"
generate "pickle --path --email"
generate "friendly_id"
generate "formtastic:install"
generate "devise:install"
generate "devise User"
generate "devise Admin"
generate "rails_admin:install_admin"

run "gem install compass"
run "compass init --using blueprint --app rails --css-dir public/stylesheets"
append_file "config/compass.rb", "require 'lemonade'"

run "rm public/stylesheets/*"

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
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/rails_admin.rb' -O config/initializers/rails_admin.rb"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/htaccess' -O public/.htaccess"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/grid.png' -O public/images/grid.png"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/app/views/layouts/anonymous.html.haml' -O app/views/layouts/anonymous.html.haml"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/app/controllers/application_controller.rb' -O app/controllers/application_controller.rb"

run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/public/javascripts/jquery-ui.min.js' -O public/javascripts/jquery-ui.min.js"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/public/javascripts/jasmine-jquery-1.2.0.js' -O public/javascripts/jasmine-jquery-1.2.0.js"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/public/javascripts/jquery.min.js' -O public/javascripts/jquery.min.js"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/public/javascripts/navigation.coffee -O public/javascripts/navigation.coffee"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/app/stylesheets/anonymous.scss -O app/stylesheets/anonymous.scss"
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/app/stylesheets/navigation.scss -O app/stylesheets/navigation.scss"

#controllers
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/app/controllers/homepage_controller.rb -O app/controllers/homepage_controller.rb
"


# replacing routes
run "wget --no-check-certificate 'https://github.com/winescout/rails3_template/raw/master/config/routes.rb -O config/routes.rb"



append_file 'Rakefile', <<-METRIC_FU

MetricFu::Configuration.run do |config|
  config.rcov[:rcov_opts] << "-Ispec"
end rescue nil
METRIC_FU

run "mkdir -p app/coffeescripts spec/javascripts spec/javascripts/templates"
run "chmod u+x build.sh"

git :init
git :add => '.'
git :add => 'public/javascripts/rails.js --force'
git :commit => '-am "Initial commit"'

puts "SUCCESS!"



