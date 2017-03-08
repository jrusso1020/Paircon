# PairCon (Conference Papers)
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

## Running Flask Application (SimiliarityAlgo Folder)
This has been developed using python 3.6. You are recommended to use Anaconda or another virtual environment

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

JSON object must look like:
```
{"user_dir" : "absolute/path/to/user_txts", "conference_dir" : "absolute/path/to/conference_txts", "k" : (number of most similiar documents to return)}
```

The server will then return a JSON object like so
```
{"1" : {"user_paper" : "absolute/path/to/user_txt", "conference_paper" : "absolute/path/to/conference_txt", "score" : (similiarity score 0-1.0)},
...,
"k" : {"user_paper" : "absolute/path/to/user_txt", "conference_paper" : "absolute/path/to/conference_txt", "score" : (similiarity score 0-1.0)}}
```
