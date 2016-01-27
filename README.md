## Rails Api Base

This projects aims to be:

* An api example to discuss about [rails](https://github.com/rails/rails)
 setup and development.
* A basic template to start projects from it.

The application itself is almost empty,
it only handles users, sessions and notes.
Here are some characteristics:

* [RESTful](https://en.wikipedia.org/wiki/Representational_state_transfer)
good practices: verbs, endpoints, status codes...
* ...api code custom versioning (by header).
* Example ('notes' objects with 'title' and 'content')
of a basic object model, controller, routes and tests.
* [Devise](https://github.com/plataformatec/devise) to handle users.
* Custom token authentication (by header) and basic session management.
* Usage of
[Concerns](http://api.rubyonrails.org/classes/ActiveSupport/Concern.html)
and other rails good practices.
* All code tested using [rspec](https://github.com/rspec/rspec) following
latest [betterspecs.org](http://betterspecs.org/) guidelines.
* [Postgres](http://www.postgresql.org/) as database.
* Rails 5.0.0.beta1 (API module) and Ruby 2.3.0.

TO-(maybe)-DO List:

* Installation and setup tutorial.
* Version expiration system.
* Secret api key verification to create users.
* Standardize i/o and use a json serialization library.
* Scripts to achieve a faster installation and setup.

An Android client base application will be developed with the same goal
and will consume data from this one.
A sample version of both will be online as soon as they are finished...

I'm not a rails experienced developer
so all suggestions and contributions are more than welcome!
