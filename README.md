# Rails Api Base

This projects aims to be:

* An api example to discuss about [rails](https://github.com/rails/rails)
 setup and development.
* A basic template to start projects from it.

The application itself is almost empty,
it only handles users, sessions and notes.
Here are the finished specifications:

* [RESTful](https://en.wikipedia.org/wiki/Representational_state_transfer)
good practices: verbs, endpoints, status codes...
* ...api code custom versioning (by header).
* Example ('notes' objects with 'title' and 'content')
of a basic object model, controller, routes and tests.
* [Devise](https://github.com/plataformatec/devise) to handle users.
* Custom token authentication (by header) and basic session management.
* Usage of
[Concerns](http://api.rubyonrails.org/classes/ActiveSupport/Concern.html)
to manage authentication and error handling,
and other rails good practices.
* All code tested using [rspec](https://github.com/rspec/rspec) following
latest [betterspecs.org](http://betterspecs.org/) guidelines.
* [Postgres](http://www.postgresql.org/) as database.
* Rails 5.0.0.beta1 (API module) and Ruby 2.3.0.
* Version expiration system.
* Secret api key verification to create users.
* Response messages internationalization by header.
* Scripts to achieve a faster installation and setup.

TO-(maybe)-DO list:

* Standardize i/o and use a json serialization library.
* Add elements pagination.
* Add sample privacy policy.

An Android client base application will be developed with the same goal
and will consume data from this one.
A sample version of both will be online as soon as they are finished...

## Quick start

* Install ruby version 2.3.0 and set it with your ruby environment manager
([more info here](https://www.ruby-lang.org/en/documentation/installation/)).

* Install Postgres and start de PostgreSQL server in the foreground
([more info here](https://wiki.postgresql.org/wiki/Detailed_installation_guides#MacOS)).

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

That's it!


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
