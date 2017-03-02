# PairCon (Conference Papers)
## Working in Development Environment:

To run the application locally, you are required to edit Hosts (```/etc/hosts```) file and add the following:
```
127.0.0.1 www.devpaircon.com
127.0.0.1 devpaircon.com
127.0.0.1 app.devpaircon.com
```

Now instead of using ```localhost``` use ```devpaircon.com``` and ```app.devpaircon.com```

## Postgres:

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

and replace

```
local   all             postgres                                peer
```

to

```
local   all             postgres                                md5
local   all             paircon                                 md5
```

#### Restart Service
```
sudo service postgresql restart
```
