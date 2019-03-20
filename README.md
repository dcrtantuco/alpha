# alpha

[![Build Status](https://travis-ci.org/dcrtantuco/alpha.svg?branch=master)](https://travis-ci.org/dcrtantuco/alpha)

Setting up a rails project takes at least one day to configure. This is my attempt to make it as fast as possible.

All files generated by rails are preserved.

Changes are made by injecting code snippets to generated files.

## tl;dr

- Working react component using [remount](https://github.com/rstacruz/remount)
- [sanitize.css](https://github.com/csstools/sanitize.css), [modularscale-sass](https://github.com/modularscale/modularscale-sass)
- [hamlit](https://github.com/k0kubun/hamlit) as templating language
- Rspec Test Suite
- [jest](https://github.com/facebook/jest), [enzyme](https://github.com/airbnb/enzyme)
- Preconfigured Linters (Rubocop, Prettier, Eslint, Stylelint)

## Getting Started

### Requirements

- ruby >= 2.6.0
- rails >= 5.2
- nodejs >= 10.15.1
- yarn

### Optional

- asdf

### Basic Usage

```
rails new appname \
  --database=postgresql \
  -m https://raw.githubusercontent.com/dcrtantuco/alpha/master/template.rb
```

### Recommended Usage

```
rails new appname \
  --database=postgresql \
  --skip-test \
  --skip-turbolinks \
  --skip-coffee \
  --asdf \
  --webpack \
  -m https://raw.githubusercontent.com/dcrtantuco/alpha/master/template.rb
```

#### Custom Flags

|  Flag  |        Description         |
| :----: | :------------------------: |
| --asdf | generates `.tool_versions` |

### Webpacker Setup

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
│   ├── packs
│   │   └── application.js
│   └── react
│       ├── components
│       │   ├── __tests__
│       │   └── Greeter.js
│       └── application.js
├── jobs
└── mailers
```

### React

Added packages:

- react
- react-dom
- babel-preset-react
- remount

### Essential packages

- [sanitize.css](https://github.com/csstools/sanitize.css) as css resets
- [modularscale-sass](https://github.com/modularscale/modularscale-sass)

### Rspec Test Suite

- Includes rspec and other gems useful in testing.
- Preconfigured with headless chromedriver
- Working rspec examples with js

|           Gem            |             Description             |
| :----------------------: | :---------------------------------: |
|       rspec-rails        |       rspec wrapper for rails       |
|    factory_bot_rails     |              fixtures               |
| rails-controller-testing | helper for rspec controller testing |
|         capybara         |     testing users' interaction      |
|    selenium-webdriver    | default driver for javascript tests |
|   chromedriver-helper    |          use chromedriver           |
|     database_cleaner     |  ensure a clean state for testing   |
|          faker           |         generate fake data          |
|      rubocop-rspec       |       rspec-specific analysis       |

### Jest and Enzyme

Added packages:

- jest
- babel-jest
- enzyme
- enzyme-adapter-react-16
- enzyme-to-json
- react-test-renderer

```js
// setupTests.js

import { configure } from 'enzyme'
import Adapter from 'enzyme-adapter-react-16'
configure({ adapter: new Adapter() })
```

```json
// package.json
"jest": {
  "roots": [
    "app/assets/javascripts",
    "app/javascript"
  ],
  "snapshotSerializers": [
    "enzyme-to-json/serializer"
  ],
  "setupFiles": [
    "./setupTests.js"
  ]
},
```

### Preconfigured Linters

Comes with initial config, can be updated to your preference!

#### Rubocop

Added gems:

- rubocop
- rubocop-rspec

Initial `rubocop_todo.yml` is generated.

```
# .rubocop.yml
inherit_from: .rubocop_todo.yml
require: rubocop-rspec

Style/FrozenStringLiteralComment:
  EnforcedStyle: never

Style/StringLiterals:
  EnforcedStyle: double_quotes

Style/HashSyntax:
  EnforcedStyle: ruby19

Layout/IndentationConsistency:
  EnforcedStyle: rails

Layout/CaseIndentation:
  EnforcedStyle: end

Layout/BlockAlignment:
  Enabled: false

Layout/EndAlignment:
  EnforcedStyleAlignWith: start_of_line

AllCops:
  Exclude:
    - 'vendor/**/*'
    - 'node_modules/**/*'
    - 'db/migrate/*'
    - 'db/schema.rb'
    - 'db/seeds.rb'
    - 'bin/*'
  TargetRubyVersion: 2.6.0
```

#### Eslint

Added packages:

- eslint
- babel-eslint
- eslint-config-prettier
- eslint-plugin-react

```js
// .eslintrc.js
module.exports = {
  plugins: ['react'],
  parser: 'babel-eslint',
  env: {
    jest: true
  },
  rules: {
    'react/prop-types': 0
  },
  extends: [
    'eslint:recommended',
    'plugin:react/recommended',
    'eslint-config-prettier'
  ],
  parserOptions: {
    ecmaFeatures: { jsx: true },
    ecmaVersion: 2018,
    sourceType: 'module'
  }
}
```

#### Prettier

Added packages:

- prettier

```js
// .prettierrc
{
  "semi": false,
  "singleQuote": true,
  "jsxSingleQuote": true
}
```

#### Stylelint

Added packages:

- stylelint
- stylelint-8-point-grid
- stylelint-config-standard
- stylelint-rscss

```js
// .stylelintrc
{
  "extends": [
    "stylelint-config-standard",
    "stylelint-rscss/config",
    "stylelint-8-point-grid"
  ],
  "rules": {
    "plugin/8-point-grid": {
      "base": 8,
      "whitelist": ["4px", "2px", "1px"]
    },
    "at-rule-no-unknown": null,
    "at-rule-empty-line-before": null
  }
}
```

### Yarn Scripts

|         Command         |               Description               |
| :---------------------: | :-------------------------------------: |
|      yarn run test      |                  jest                   |
|   yarn run lint:ruby    |                 rubocop                 |
|    yarn run lint:js     |                 eslint                  |
|    yarn run lint:css    |                stylelint                |
| yarn run prettier:check |                prettier                 |
|  yarn run prettier:fix  |                prettier                 |
|    yarn run lint:ci     | rubocop eslint stylelint prettier:check |

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

## License

MIT
