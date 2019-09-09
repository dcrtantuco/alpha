#!/usr/bin/env bats

load '../node_modules/bats-support/load'
load '../node_modules/bats-assert/load'

WORKSPACE=$(mktemp -d)

setup() {
  cd $WORKSPACE
}

teardown() {
  if [ $BATS_TEST_COMPLETED ]; then
    echo "Deleting $WORKSPACE"
    rm -rf $WORKSPACE
  fi
}

@test 'Basic Usage' {
  # exit 0
  rails new appname \
    --database=postgresql \
    --skip-test \
    --skip-turbolinks \
    --skip-coffee \
    -m https://raw.githubusercontent.com/dcrtantuco/alpha/master/template.rb

  # webpacker setup
  assert [ -e "$WORKSPACE/appname/app/javascript/packs/application.js" ]

  # essential yarn packages
  run bash -c "cat $WORKSPACE/appname/package.json | grep sanitize"
  assert_success

  cd appname

  # rspec passes
  run rspec
  assert_success

  # linter works
  run yarn run lint:ci
  assert_success

  # jest works
  run yarn run test
  assert_success

  # output rails app has no uncommitted changes
  run git status
  refute_output --partial 'untracked files present'

  # no asdf
  refute [ -e "$WORKSPACE/appname/.tool-versions" ]

  # no typescript
  refute [ -e "$WORKSPACE/appname/app/javascript/react/components/Greeter.tsx" ]
}

@test 'Custom flags' {
  rails new appname \
    --typescript \
    --asdf \
    --webpack \
    -m https://raw.githubusercontent.com/dcrtantuco/alpha/master/template.rb

  # rspec passes
  run rspec
  assert_success

  # output rails app has no uncommitted changes
  run git status
  refute_output --partial 'untracked files present'

  # asdf
  assert [ -e "$WORKSPACE/appname/.tool-versions" ]

  # typescript
  assert [ -e "$WORKSPACE/appname/app/javascript/react/components/Greeter.tsx" ]
}
