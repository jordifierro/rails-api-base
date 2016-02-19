# Rails Api Base

[![Code Climate](https://codeclimate.com/github/jordifierro/rails-api-base/badges/gpa.svg)](https://codeclimate.com/github/jordifierro/rails-api-base)
[![Test Coverage](https://codeclimate.com/github/jordifierro/rails-api-base/badges/coverage.svg)](https://codeclimate.com/github/jordifierro/rails-api-base/coverage)
[![Build Status](https://travis-ci.org/jordifierro/rails-api-base.svg?branch=master)](https://travis-ci.org/jordifierro/rails-api-base)

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
* Users and token authentication.
* Version expiration.
* Internationalization.
* Secret api key.
* Rspec testing.
* Setup scripts.
* Postgres database.
* Last versions.


## Quick start

* Install ruby version 2.3.0 and set it with your ruby environment manager
([more info here](https://www.ruby-lang.org/en/documentation/installation/)).

* Install Postgres and start de PostgreSQL server in the foreground
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

* Once all tests are green, create a new remote repository and then execute this to reset the repo and push it:
```
./bin/reset_git https://github.com/yourusername/your-project-name.git
```

That's it, you can now start developing your own app!

## Documentation

The application itself is almost empty,
it only aims to provide some basic modules,
implement the structures for some patterns and give some sample code.
Here are the specifications:

#### RESTful Api
The app includes only the rails-api related modules, so it's thinner than a normal app but lacks some features (that can be manually added if required).
The architecture of the api follows rails and http restful good practices
such as:
* Usage of http methods/verbs.
* Good structured endpoints.
* Return appropriate status code.

#### Api Versioning
The endpoint routes and the code structure are ready to add new api versions.
The version is chosen via `headers['Accept']` with values like
`application/vnd.railsapibase.v1` to use the first version, for example.

#### Notes Example Code
To fill the app with sample code, it has been developed code to manage `notes`
(handwritten paper notes), composed by a `title` and a `content`.
Thus, the app has the notes routes, controller, model and rspecs
to handle that notes.

Its unique purpose is to be a guide of how to add new code,
so it can be deleted when it's useless.

#### Concerns and ApiController Pattern

To structure the global controller features of the api,
different modules have been implemented as
[Concerns](http://api.rubyonrails.org/classes/ActiveSupport/Concern.html)
and tested using fake controllers.
Those modules are included to the ApiController,
which is the father controller of the rest of controllers.
At the moment there are 4 modules: user and authentication, error handling,
internationalization and version expiration.

#### Users Management and Token Authentication
Almost every api requires users, sessions and authentications,
so it's really useful to add this feature to our base app.
The chosen solution is a mix that uses
[Devise gem](https://github.com/plataformatec/devise)
and a custom implementation to handle sessions by token.
A token is returned when the users loggin
and it has to be set to `headers['Authorization']`
on later requests to authenticate them.

#### Version Expiration System
To check if a version can still be used,
there's a module that filters that before each method call.
It will return error if the version has expired
and there's also an endpoint to check the expiration date from the client
(e.g.: to warn the user to update the app).
If you want to set expiration date to a concrete version,
simply set a date formatted to string to `ENV['V1_EXPIRATION_DATE']`.

#### Internationalization
The app is translated to English (default language)
and Spanish (just as translation example).
There is a simple module that chooses the locale from
`request.env['HTTP_ACCEPT_LANGUAGE']` and set it to the system
to automatically return the appropriate translation.

#### Secret Api Key
In order to add some control to the api clients,
there's an secret api key verification system that can be
activated to make sure that is a valid client
who creates the user.
To activate this service
just set a value to `ENV['SECRET_API_KEY']`.
The secret api key must be sent at `headers['Authorization']`
(it will be used later to send the auth token).

#### Rspec Testing
That base project has been developed using TDD process
and all code is tested using Rspec, following best practices guidelines defined at
[betterspecs.org](http://betterspecs.org/).
It's important to keep it that way.

#### Setup scripts
To avoid the burden of manually modify the code to prepare
the files to start a new project, some scripts
have been implemented. You can find them inside `bin/` folder.

#### Postgres Database
To avoid deployment problems,
[Postgres](http://www.postgresql.org/) database
has been chosen from the beginning as the database system for testing and development.
The fact that [Heroku](https://www.heroku.com/)
uses it as its default db system has been considered too.

#### Latest Rails and Ruby Versions
The project uses Rails 5.0.0.beta2 (API module) and Ruby 2.3.0
and intends to be kept up to date.


#### Todo List

- [ ] Standardize json i/o and add a serialization library.
- [ ] Add elements pagination.
- [ ] Add sample privacy policy.
- [x] Upgrade to ruby and rails latest versions.

An Android client base application
will be developed with the same goal as this.
It will consume data from this one.
A sample version of both will be online
as soon as they are finished...


## Contribute

I'm not a rails experienced developer
so all suggestions and contributions are more than welcome!

* Fork this repo.
* Create your feature branch (git checkout -b feature-name).
* Commit your changes (git commit -m 'Implement new function').
* Push the changes (git push origin feature-name).
* Create a pull request and I'll merge it with the project.

#### Contributors

Unfortunately, there are no contributors yet.
