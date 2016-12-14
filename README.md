# Rails Api Base

[![Code Climate](https://codeclimate.com/github/jordifierro/rails-api-base/badges/gpa.svg)](https://codeclimate.com/github/jordifierro/rails-api-base)
[![Test Coverage](https://codeclimate.com/github/jordifierro/rails-api-base/badges/coverage.svg)](https://codeclimate.com/github/jordifierro/rails-api-base/coverage)
[![Build Status](https://travis-ci.org/jordifierro/rails-api-base.svg?branch=master)](https://travis-ci.org/jordifierro/rails-api-base)
[![Dependency Status](https://gemnasium.com/jordifierro/rails-api-base.svg)](https://gemnasium.com/jordifierro/rails-api-base)

## Introduction

This projects aims to be:

* An api example to discuss about Rails
 setup and development.
* A basic template to start projects from it.

Specification summary:

* RESTful api.
* Api versioning.
* Notes app example.
* Patterns and good practices.
* Users management.
* Version expiration.
* Internationalization.
* Secret api key.
* Rspec testing.
* Setup scripts.
* Postgres database.
* Versions up-to-date.
* Ruby Style Guide.
* Json serialization

Here is its counterpart client mobile app that consumes data from this api ->
[android-base](https://github.com/jordifierro/android-base)


## Quick start

* Install ruby version 2.3.0 and set it with your ruby environment manager
([more info here](https://www.ruby-lang.org/en/documentation/installation/)).

* Install Postgres and start the PostgreSQL server in the foreground
([more info here](https://wiki.postgresql.org/wiki/Detailed_installation_guides)).

* Clone the repository and get inside it:
```
git clone git://github.com/jordifierro/rails-api-base.git --origin rails-api-base your-project-name
cd your-project-name
```

* Rename whole project and reset README.md:
```
./bin/rename_project YourProjectName
```

* Remove all 'note' related code (optional):
```
./bin/remove_notes
```

* Create a postgres role to let rails manage the db:
```
./bin/create_psql_user yourprojectname
```

* Setup the gems and databases:
```
./bin/setup
```

* Run tests:
```
rspec
```

* Once all tests are green, create a new remote repository
and then execute this to reset the repo and push it:
```
./bin/reset_git https://github.com/yourusername/your-project-name.git
```

That's it, you can now start developing your own app!

(While developing on localhost, start [mailcatcher](https://github.com/sj26/mailcatcher)
in order to receive user confirmation and recover password emails)
```
gem install mailcatcher
mailcatcher
```

## Documentation

The application itself is almost empty,
it only aims to provide some basic modules,
implement the structures with some patterns and give sample code.
Here are the specifications:

#### RESTful Api
The app includes only the rails-api related modules,
so it's thinner than a normal app but lacks some features
(that can be manually added if required).
The architecture of the api follows rails and http restful good practices
such as:
* Usage of http methods/verbs.
* Structured endpoints.
* Return appropriate status code.

#### Api Versioning
The endpoint routes and the code structure are ready to add new api versions.
The version is chosen via `headers['Accept']` with values like
`application/vnd.railsapibase.v1` to use the first version.

#### Notes Example Code
To provide the app sample code, it has been developed code to manage `notes`
(like handwritten paper notes representation),
composed by a `title` and a `content`.
Thus, the app has the notes routes, controller, model and rspecs
to work with that notes.

Its unique purpose is to be a guide of how to add new code,
so it will be deleted by the `bin/remove_notes` shell script.

#### Concerns and ApiController Pattern
[![Code Climate](https://codeclimate.com/github/jordifierro/rails-api-base/badges/gpa.svg)](https://codeclimate.com/github/jordifierro/rails-api-base)

To structure the global controller features of the api,
different modules have been implemented as
[ActiveSupport::Concern](http://api.rubyonrails.org/classes/ActiveSupport/Concern.html)
and tested using fake controllers.
Those modules are included to the ApiController,
which is the father controller of the rest of controllers
([check this post](http://jordifierro.com/rails-apicontroller-and-concerns)).
At the moment there are 4 modules: authentication, error handling,
internationalization and version expiration
([check this other](http://jordifierro.com/rails-api-modules)).
[Code Climate](https://codeclimate.com/) is the service used
to check that this and all the rest of the code follows good practices
(you have to activate it for your project to use it).

Codeclimate can also be run locally with its
[CLI](https://github.com/codeclimate/codeclimate).


#### Users Management
Almost every api requires users, sessions and authentications,
so this is the most important feature of this app.
The chosen solution uses `has_secure_password` and `has_secure_token`
with a custom implementation to handle sessions and users:

* Create and delete users.
* Login and logout users.
* Authenticate users by token.
* Confirm email with sending an email with token.
* Reset password when forgotten with email verification.

A token is returned when the users login
and it has to be set to `headers['Authorization']`
on later requests to authenticate them.
More info about that on
([this post](http://jordifierro.com/rails-api-modules#authenticator))

#### Version Expiration System
To check if a version can still be used,
there's a module that filters that before each method call.
It will return error if the version has expired
and there's also an endpoint to check the expiration date from the client
(e.g.: to warn the user to update the app).
If you want to set expiration date to a concrete version,
simply set a integer formatted to string to `ENV['LAST_EXPIRED_VERSION']`.
All versions equal or below the specified will send upgrade error message
when asked. The system to set a warning to some versions is the same,
using `ENV['LAST_WARNED_VERSION']` to set the higher version that you want
to warn.
More info about that on
([this post](http://jordifierro.com/rails-api-modules#version-expiration-handler))

#### Internationalization
The app is translated to English (default language)
and Spanish (just as translation example).
There is a simple module that takes the locale from
`request.env['HTTP_ACCEPT_LANGUAGE']`
(that can be set throught the `Accept-Languange` header)
and sets it to the system
to automatically return the appropriate translation.
More info about that on
([this post](http://jordifierro.com/rails-api-modules#internationalizator))

To test that all needed translations are set for an specific language,
uncomment the following line to the `spec_helper.rb` file,
place there the target language and run `rspec`:
```
I18n.default_locale = :es
```

#### Secret Api Key
In order to add some control over the api clients,
there's an secret api key verification system that can be
activated to make sure that is a valid client
who creates the user.
To activate this service
just set a value to `ENV['SECRET_API_KEY']`.
The secret api key must be sent at `headers['Authorization']`
when calling create new user method.

#### Rspec Testing
[![Test Coverage](https://codeclimate.com/github/jordifierro/rails-api-base/badges/coverage.svg)](https://codeclimate.com/github/jordifierro/rails-api-base/coverage)
[![Build Status](https://travis-ci.org/jordifierro/rails-api-base.svg?branch=master)](https://travis-ci.org/jordifierro/rails-api-base)

This project has been developed using TDD process
and all code is tested using Rspec,
following best practices guidelines defined at
[betterspecs.org](http://betterspecs.org/).
It's important to keep it that way.
[Code Climate](https://codeclimate.com/) checks
that the tests cover all the code cases.
[Travis-CI](https://travis-ci.org/) is a continous integration system
that runs the tests every time a push is made.
If you want to use this services, you have to enable them at their websites.
If you don't, simply delete the `.travis.yml` file.

#### Setup scripts
To avoid the burden of manually modify the code to prepare
the files to start a new project, some scripts
have been implemented. You can find them inside `bin/` folder
(they are self destroyed after use).

They have been analyzed by
[ShellCheck](https://github.com/koalaman/shellcheck).

#### Postgres Database
To avoid deployment problems,
[Postgres](http://www.postgresql.org/) database
has been setup from the beginning
as the database system for testing and development.
The fact that [Heroku](https://www.heroku.com/)
uses it as its default db system has been considered too.

#### Latest Ruby and Gems Versions
[![Dependency Status](https://gemnasium.com/jordifierro/rails-api-base.svg)](https://gemnasium.com/jordifierro/rails-api-base)

The project uses Rails 5.0.0.beta3 (API module) and Ruby 2.3.0
and intends to be kept up to date using
[Gemnasium](https://gemnasium.com) service.
You must activate this service for your repo if you want to use it.

#### Follow Ruby Style Guide
In order to increase the code elegance and readability,
this [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide)
has been used as reference.
[Rubocop gem](https://github.com/bbatsov/rubocop)
is a Ruby static code analizer based on that style guide.
Just run:
```
gem install rubocop
rubocop
```
Remember that `.rubocop.yml` file defines the configuration
(remove it if not used).

#### Json output serialization
The responses are formatted using the
[ActiveModelSerializers](https://github.com/rails-api/active_model_serializers)
gem.
Serializers are responsible to format the output json,
and are a good way to decouple this layer from models and controllers.
Furthermore, they are versioned like controllers (e.g.: `Api::V1::Serializer`)
because they directly interfere with the output of each api version.
This will help us keeping old version contracts.

#### Todo List

- [ ] Add elements pagination.
- [x] Upgrade to ruby and rails latest versions.


Here is its counterpart client mobile app that consumes data from this api ->
[android-base](https://github.com/jordifierro/android-base)


## Contribute

I'm not a rails experienced developer
so all suggestions and contributions are more than welcome!

* Fork this repo.
* Create your feature branch (git checkout -b feature-name).
* Develop your feature and test it.
* Run tests and code style checker successfully:
```
rspec
rubocop
```
* Commit your changes (git commit -m 'Implement new function').
* Push the changes (git push origin feature-name).
* Create a pull request and I'll merge it with the project.

#### Contributors

Unfortunately, there are no contributors yet.

______________________
http://jordifierro.com
