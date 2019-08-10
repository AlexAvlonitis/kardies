## ![Kardies logo](/logo_cover.jpg)
[![Build Status](https://travis-ci.org/AlexAvlonitis/kardies.svg?branch=master)](https://travis-ci.org/AlexAvlonitis/kardies)
### An opensource Greek dating website. [Kardies.gr](https://kardies.gr)

## How to run locally

* ```bundle install```
* Copy .env.example file and paste to .env(only the last two need to be real for the tests to pass):
* ```bundle exec rake db:setup```
* ```bundle exec puma```
* Go to http://localhost:3000, login with email: test_0@test.com password: password

**Dependencies/Requirements**

* Ruby 2.6.3
* Redis (Not required for the dev environment)
* Elastic Search 6.8.2
* Imagemagick
* MySQL
* AWS S3 bucket

## Contributing

All Pull Requests are welcome, from a simple typo to a new feature.

* Fork this repo
* Run the tests with ```bundle exec rspec```
* Create a new branch, add your changes with tests when necessary
* Submit a Pull Request

## License
[GNU AFFERO GENERAL PUBLIC LICENSE](/LICENSE)
