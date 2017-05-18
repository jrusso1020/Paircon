# PairCon (Conference Papers)
This ReadMe has been tested for a Ubuntu Environment. There may be changes associated with executing the same commands in MacOSX or Microsoft Windows. 
Please document any changes that you find in setup of the project. 

## Running All the Apps and Postgres (Optional)
globally install the gem foreman
```
gem install foreman
```

from the root directory `/Conference-Papers` run the command
```
foreman s
```

## Working in Development Environment:

To run the application locally, you are required to edit Hosts (```/etc/hosts```) file and add the following:
```
127.0.0.1 www.devpaircon.com
127.0.0.1 devpaircon.com
127.0.0.1 app.devpaircon.com
```

On Mac: [instructions to edit (```/etc/hosts```)](http://www.imore.com/how-edit-your-macs-hosts-file-and-why-you-would-want)

## Postgres:

On Mac: [instructions to install Postgres](https://launchschool.com/blog/how-to-install-postgresql-on-a-mac)

The application is setup to work with Postgres. After installing postgres, you are required to do the following:

#### Open postgres user:
```
sudo su - postgres
```
#### Open PSQL using:
```
psql
```

#### Create a database user
```
create role paircon with createdb login password 'paircon';
```
#### Open
```
vim /etc/postgresql/<version>/main/pg_hba.conf
```
If using Mac: find the of hba.conf file instead. In PSQL, type
```
SHOW hba_file;
```

and replace

```
local   all             postgres                                peer
```

to

```
local   all             postgres                                md5
local   all             paircon                                 md5
```
If using Mac, just add these two lines to the file. 

#### Restart Service
```
sudo service postgresql restart
```

## Running Rails Application (Web Folder)
To start the server use the following commands
```
bundle install
rake db:create --is required once
rake db:migrate
rails s
```

Now instead of using ```localhost``` use ```devpaircon.com``` and ```app.devpaircon.com``` to open the application

#### pdftotext 
Make sure you have the command `pdftotext` installed. Just type `pdftotext` into terminal and see if it gives you the usage or says command not found. If it says command not found on mac do `brew cask install pdftotext` to get it. You need this command to use the profile web scraper to get a users publications

## Running Rails Background Services (Web Folder)
PairCon highly relies on background services to provide async behavior while downloading and generating recommendations.
The system uses Redis along with Sideqik. You will be required to do the following:

#### Install Redis
[instructions to install on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04)

[instructions to install on Mac](https://medium.com/@petehouston/install-and-config-redis-on-mac-os-x-via-homebrew-eb8df9a4f298#.pdgap142h)

#### Run Redis Server
You can setup redis as a service or execute ```redis-server``` to start a redis instace. 
#### Run Sidekiq
Background Agents live on Sidekiq and thus you are required to execute the following command once when you begin development:

```
bundle exec sidekiq -q default -q mailers
```

Note: Redis is knowing for using a lot of memory and sometimes causes a lot of memory problems. You may want to restrict the maximum memory you are 
willing to allow redis to use. You can do this in ```redis.conf``` which can be found usually in ```/etc/redis/redis.conf```

## Running Flask Application (SimiliarityAlgo Folder)
This has been developed using python 3.6. You are recommended to use Anaconda or another virtual environment. You can also run this on Python 2.7. 

Make sure you have a fortran compiler installed. On Mac, you can use `brew install gcc` to accomplish this. 

To install all packages and clean up the directory afterwards do
```
python setup.py install
python setup.py clean
```

Then to run do
```
python app.py
```

This will run the app at 127.0.0.1:5000

#### Sending POST requests
Requires content of POST request to be `application/json`

JSON object must look like this when sending to api endpoint `/similiarity/v1/compare`:
```
{"user_dir" : "absolute/path/to/user_txts", "conference_dir" : "absolute/path/to/conference_txts", "k" : (number of most similiar documents to return)}
```

The server will then return a JSON object like so
```
{"1" : {"user_paper" : "absolute/path/to/user_txt", "conference_paper" : "absolute/path/to/conference_txt", "score" : (similiarity score 0-1.0)},
...,
"k" : {"user_paper" : "absolute/path/to/user_txt", "conference_paper" : "absolute/path/to/conference_txt", "score" : (similiarity score 0-1.0)}}
```
JSON object must look like this when sending to api endpoint `/similiarity/v1/compare/single`:
```
{"user_file" : "absolute/path/to/user_file.txt", "conference_dir" : "absolute/path/to/conference_txts"}
```

The server will then return a JSON object like so
```
{'user_paper': '/Users/james/Documents/kilian_text/6139-supervised-word-movers-distance.txt', 'conference_paper': '/Users/james/Documents/conference_text/10.1.1.86.3414.txt', 'score': 0.17010696572993009}
```
## Documentation
Documentation for the project in Rails is built using [Yard](http://yardoc.org/). To run the documentation server use:
```
yard server --reload
```

You can view your documentation and changes live at 127.0.0.1:8808

## Testing
To run the entire test suite use the commands
`bundle exec rake` or `bundle exec rspec`

#### Using Guard
While creating testcases you can use the command `bundle exec guard` which runs guard.
This gem will automatically run whatever `*_spec.rb` file you just saved so you don't have to run the whole test suite each time.

#### Loading Fixtures
You can use fixtures in the rails console instead of your own database to test, this is down with the commands
```
bundle exec rake db:fixtures:load RAILS_ENV=test
bundle exec rails c test
```

