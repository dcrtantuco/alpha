require 'fileutils'
require 'shellwords'

# Copied from https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require 'tmpdir'
    source_paths.unshift(tempdir = Dir.mktmpdir('alpha-'))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      '--quiet',
      'https://github.com/dcrtantuco/alpha.git',
      tempdir
    ].map(&:shellescape).join(' ')

    if (branch = __FILE__[%r{alpha/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def add_testing_gems
  gem_group :development, :test do
    gem 'factory_bot_rails'
    gem 'rails-controller-testing'
    gem 'rspec-rails'
  end

  gem_group :test do
    gem 'capybara'
    gem 'database_cleaner'
    gem 'faker'
    gem 'selenium-webdriver'
  end
end

def setup_package_json
  remove_file 'package.json'
  template 'package.json.erb', 'package.json'
end

def add_essential_packages
  run 'yarn add sanitize.css'
end

def add_linter_packages
  run 'yarn add --dev \
    stylelint \
    stylelint-config-standard \
    stylelint-rscss \
    stylelint-8-point-grid'
end

def copy_linter_files
  copy_file '.stylelintrc', '.stylelintrc'
end

def initial_commit
  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end

def setup_homepage_template
  # routes
  route "root to: 'home#index'"

  # controllers
  copy_file 'app/controllers/home_controller.rb', 'app/controllers/home_controller.rb'

  # views
  copy_file 'app/views/home/index.html.erb', 'app/views/home/index.html.erb'

  # layout
  remove_file 'app/views/layouts/application.html.erb'
  copy_file 'app/views/layouts/application.html.erb', 'app/views/layouts/application.html.erb'
end

def setup_assets_folder_structure
  remove_file 'app/javascript/packs/application.js'

  # css
  copy_file 'app/javascript/css/application.scss', 'app/javascript/css/application.scss'
  copy_file 'app/javascript/css/vendor.scss', 'app/javascript/css/vendor.scss'
  copy_file 'app/javascript/css/components/home-page.scss', 'app/javascript/css/components/home-page.scss'

  # images
  copy_file 'app/javascript/images/application.js', 'app/javascript/images/application.js'
  copy_file 'app/javascript/images/rails-logo.svg', 'app/javascript/images/rails-logo.svg'

  # js
  copy_file 'app/javascript/js/application.js', 'app/javascript/js/application.js'

  # packs
  copy_file 'app/javascript/packs/application.js', 'app/javascript/packs/application.js'
end

def setup_asdf
  copy_file '.tool-versions', '.tool-versions'
end

def post_install_requirements
  # create db
  run 'bundle exec rails db:create'

  # db migrate
  run 'bundle exec rails db:migrate'

  # webpacker
  run 'bundle exec rails webpacker:install'

  # rspec
  run 'bundle exec rails generate rspec:install'
end

def check_ruby_version; end

def add_rspec_examples
  # models
  copy_file 'spec/models/.keep', 'spec/models/.keep'

  # controllers
  copy_file 'spec/controllers/home_controller_spec.rb', 'spec/controllers/home_controller_spec.rb'

  # features
  copy_file 'spec/features/visitor_sees_homepage_spec.rb', 'spec/features/visitor_sees_homepage_spec.rb'
end

check_ruby_version
add_template_repository_to_source_path
setup_asdf

add_testing_gems
setup_homepage_template

setup_package_json
add_essential_packages
add_linter_packages
copy_linter_files

after_bundle do
  post_install_requirements
  setup_assets_folder_structure
  add_rspec_examples
  initial_commit
end
