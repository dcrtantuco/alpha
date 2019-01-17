# alpha

Setting up a rails project takes at least one day to configure.

This is my attempt to make it as fast as possible.

## Getting Started

### Requirements

- ruby 2.6.0
- rails 5.2
- nodejs 10.4.0
- yarn

I recommend using `asdf` to manage ruby and nodejs versions.

### Basic Usage

```
rails new appname \
  -m https://raw.githubusercontent.com/dcrtantuco/alpha/master/template.rb
```

### Recommended Usage

```
rails new appname --database=postgresql --skip-test \
  --skip-sprockets --skip-turbolinks --skip-coffee \
  --skip-javascript --webpack \
  -m https://raw.githubusercontent.com/dcrtantuco/alpha/master/template.rb
```

## Features

- Initial Webpacker Setup (`--webpack`)
- Essential npm packages (`--webpack`)
- Use [hamlit](https://github.com/k0kubun/hamlit) as templating language
- Rspec test suite
- Preconfigured linters
- Scripts

### Initial Webpacker Setup

#### Folder Structure

```
├── app
├── channels
├── assets
├── channels
├── javascript
│   ├── css
│   │   ├── components
│   │   │   └── home-page.scss
│   │   ├── application.scss
│   │   └── vendor.scss
│   ├── images
│   │   ├── application.js
│   │   └── rails-logo.svg
│   ├── js
│   │   └── application.js
│   └── packs
│       └── application.js
├── jobs
└── mailers
```

### Essential packages

- sanitize.css

### Rspec test suite

Includes rspec and other gems useful in testing.

```ruby
gem_group :development, :test do
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem "rubocop", require: false
  gem 'rubocop-rspec'
end

gem_group :test do
  gem 'capybara'
  gem 'chromedriver-helper'
  gem 'database_cleaner'
  gem 'faker'
  gem 'selenium-webdriver'
end
```

### Preconfigured linters

- Rubocop
- Eslint
- Prettier
- Stylelint

### Scripts

|         Command         |               Description                |
| :---------------------: | :--------------------------------------: |
|   yarn run lint:ruby    |                 rubocop                  |
|    yarn run lint:js     |                  eslint                  |
|    yarn run lint:css    |                stylelint                 |
| yarn run prettier:check |             prettier-eslint              |
|  yarn run prettier:fix  |             prettier-eslint              |
|    yarn run lint:ci     | rubocop eslint stylelint prettier-eslint |

## Post Install Guide

### Convert existing erb files to haml

1. Install html2haml

   ```
   $ gem install html2haml
   ```

1. Convert erb files to haml (keeps original file)

   ```
   $ find . -name \*.erb -print | sed 'p;s/.erb$/.haml/' | xargs -n2 html2haml
   ```

1. Delete existing erb files

   ```
   $ find . -name \*.erb | xargs git rm
   ```

1. Commit the changes.
1. Uninstall

   ```
   $ gem uninstall html2haml
   ```

## TODO

- Finish post setup of essential gems
- Improve homepage style
- Initial react setup
- Add sample js tests
- Docker setup and instructions
- Circleci config and instructions

## License

MIT
