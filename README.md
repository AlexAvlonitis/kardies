## ![Kardies logo](/logo_cover.jpg)
[![ci](https://github.com/AlexAvlonitis/kardies/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/AlexAvlonitis/kardies/actions/workflows/ci.yml)
### An opensource Greek dating website, backend API. [Kardies.gr](https://kardies.gr)

## How to run locally

* ```bundle install```
* Copy .env.example file and paste to .env (Change where necessary)
* ```bundle exec rake db:setup```
* ```bundle exec puma```
* To run tests: `bundle exec rspec`
* server running on: localhost:3000

## With docker
Requirements: Docker && docker-compose
* Copy .env.example file and paste to .env (Enough for tests to run)
* Run the services: `docker-compose up`
* Build/seed the DB (only once): `docker-compose run --rm api rails db:setup`
* Run the tests: `docker-compose run --rm api rspec`
* server running on: localhost:3000


### LOGIN
* curl login request example:
```
curl --request POST \
  --url http://localhost:3000/oauth/token \
  --header 'content-type: application/json' \
  --data '{
	"email": "test_0@test.com",
	"password": "password",
	"grant_type": "password"
}'
```

**Dependencies/Requirements for manual installation**

* Ruby 3.3.5
* Redis (Not required for the dev environment)
* Elastic Search ~> 7
* Imagemagick
* MySQL

## Contributing

All Pull Requests are welcome, from a simple typo to a new feature.

* Fork this repo
* Run the tests
* Create a new branch, add your changes with tests when necessary
* Submit a Pull Request

## License
[GNU AFFERO GENERAL PUBLIC LICENSE](/LICENSE)
