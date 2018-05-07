## ![Kardies logo](/logo_cover.jpg)
[![Build Status](https://travis-ci.org/AlexAvlonitis/kardies.svg?branch=master)](https://travis-ci.org/AlexAvlonitis/kardies)
### An opensource Greek dating website. [Kardies.gr](https://kardies.gr)

## How to run locally

* ```bundle install```
* Create a .env file with the below ENV variables(only the last two need to be real for the tests to pass):
  * FB_APP_ID=test
  * FB_APP_SECRET=secret
  * S3_BUCKET_NAME=s3_aws_bucket
  * AWS_ACCESS_KEY_ID=aws_id
  * AWS_SECRET_ACCESS_KEY=aws_secret
  * AWS_REGION=aws_region
  * DBPASS=real_dev_db_password
  * DBUSER=real_dev_db_username
* ```bundle exec rake db:setup```
* ```bundle exec puma```
* Go to http://localhost:3000, login with email: test_0@test.com password: password

**Dependencies/Requirements**

* Ruby 2.3.1 (We use rbenv)
* Redis (Not required for Dev environment)
* Elastic Search 5.6.9
* Imagemagick
* MySQL
* AWS S3 bucket for uploading pictures. (Not a requirement for Dev environment).

## Contributing

All Pull Requests are welcome, from a simple typo to a new feature.

* Fork this repo
* Run the tests with ```bundle exec rspec```
* Create a new branch, add your changes with tests when necessary
* Submit a Pull Request

## License
[GNU AFFERO GENERAL PUBLIC LICENSE](/LICENSE)
