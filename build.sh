#!/bin/sh

set -e

# Switching Gemfile
set_gemfile(){
  echo "Switching Gemfile..."
  export BUNDLE_GEMFILE="`pwd`/Gemfile"
}

# Target postgres. Override with: `DB=sqlite bash build.sh`
export DB=${DB:-postgres}

# Set retry count at 2 for flakey poltergeist specs.
export RSPEC_RETRY_COUNT=2

# Spree defaults
echo "Setup SpreeAbc defaults and creating test db..."
bundle check

# Spree Abc
echo "**************************************"
echo "* Setup Spree Abc and running RSpec..."
echo "**************************************"
bundle update --quiet; bundle exec rspec spec

# Spree Theme
echo "******************************************"
echo "* Setup Spree Theme and running RSpec...  "
echo "******************************************"
cd ./spree_theme; set_gemfile; bundle update --quiet; bundle exec rspec spec

# Spree Mulit-Site
echo "***************************************"
echo "* Setup Spree Mulit-Site and running RSpec..."
echo "***************************************"
cd ../spree_multi_site; set_gemfile; bundle update --quiet; bundle exec rspec spec

# Spree Frontend
#echo "*******************************************"
#echo "* Setup Spree Frontend and running RSpec..."
#echo "*******************************************"
#cd ../frontend; set_gemfile; bundle update --quiet; bundle exec rspec spec

# Spree Sample
#echo "*****************************************"
#echo "* Setup Spree Sample and running RSpec..."
#echo "*****************************************"
#cd ../sample; set_gemfile; bundle update --quiet; bundle exec rspec spec
