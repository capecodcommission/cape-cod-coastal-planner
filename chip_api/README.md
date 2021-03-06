# ChipApi

**Cape Cod Coastal Planner API**

> This API serves coastal strategy information from a PostgreSQL database to a front-end 


## Getting started

Create  `/config/dev.secret.exs` and `/config/test.secret.exs` containing the PostgreSQL server password.

Change the line-ending format of `startup.sh` from CRLF (Windows) to LF (Unix)

```bash
# Nativgate to project folder directory
cd cape-cod-coastal-planner/

# Run API service
docker-compose up --build api
```
Now you can visit [`localhost:4000/graphiql`](http://localhost:4000/graphiql) from your browser and query the API.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).


## Back-end Development

### Migrations
```bash
# Adding a migration to /priv/repo/migrations/
mix ecto.gen.migration name_of_migration

# Modify new migration within /priv/repo/migrations/

# Once new migration is modified, generate new migrations.sql file
mix dump
```

### Seeders
## Kubernetes
In both uat and master branches, disable API server instantiation by commenting out `mix phx.server` in `/chip_api/startup.sh`
```bash
# exec into postgres container
kubectl exec -it cccpdb-1234567 -- /bin/bash

# Change to user postgres
su - postgres

# Stop all current connections to dev db
psql -U postgres -d chip_api_dev -c "select pg_terminate_backend(pid) from pg_stat_activity where datname='chip_api_dev';"

```
Modify seed files at `/dev/support/seeds.ex` and `/prod/support/seeds.ex`
Uncomment mix ecto.reset in `/chip_api/startup.sh` to dump and rebuild DB schema

```bash
# Generate new seeds.sql file with new seed changes
# Prompt should appear for Postgres password
dev/support/dump_seeds.bat

# Replace existing seeds.sql with new privreposeeds.sql
```

### GraphQL
If new migrations and seeders create queryable properties, those properties must be added to the GraphQL schema in order to be queryable.
For example: 
  * Adding a migration to add a column to `adaptation_strategies` table and seeding it with data
    * Requires new property to be added to `/lib/chip_api/adaptation/strategy.ex` as well as `/lib/chip_api_web/schema/strategy_types.ex`

### GraphQL -> Front-end
Any new queryable property must be added to front-end data types in order to be used by front-end
For example:
  * New `adapatation_strategies` property in GraphQL requires exposing new property in front-end in `chip_app/src/AdaptationStrategy/`

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


## More Commands cheatsheet

  * `mix help <command>`
    * print help documentation for a given command
  * `set "MIX_ENV=<env>" && mix <command> <args>`
    * set your mix env (ie: to `prod`) when not running against the default of `dev`
  * `mix deps.clean --all`
    * clean out deps
  * `set "MIX_ENV=prod && mix release --env=prod`
    * build a production release
  * `set "MIX_ENV=prod && mix release.clean`
    * clean out release files but leave generated release configuration
  * `set "MIX_ENV=prod && mix release.clean --implode`
    * completely clean out entire release folder
  * `mix ecto.dump -d my_file.sql`
    * create a sql dump of database migrations
  * `mix test`
    * run all tests
  * `mix test --only <moduletag>`
    * run tests that include a given modeule tag and no others
  * `dev\support\dump_seeds.bat`
    * dumps a `seeds.sql` file to `priv\repo`


## Production Server Prerequisites
Prerequisites

Centos7 server
  2cpu
  4 gig RAM
  30gig storage
  must have access to internet to download packages
  must be accessible on port 80 to browse to app

Instructions

!! IMPORTANT !! You should change the value of the CHIP_DB_PASSWORD.  The values is near the top of the script for ease of change.  Also, watch script output... after a few minutes, it will prompt for password for 'shawnmgoulet' to clone the bitbucket repo.  The script does not handle an invalid password well... and you might need to start all over with a new VM if you mistype your password during this step.

Log in to VM
Become root user (i.e. 'sudo su -')
Copy setup script to home folder
Make sure setup script is executable
Execute script (i.e. './setup.sh')

The script is somewhat well commented and organized.
It first updates all of the OS packages.
Then installs some tools such as git, npm, node, elixir, etc.
It installs PostgreSQL database server

It creates a 'chipdev' user
It creates a 'build.sh' script in the home folder of the 'chipdev' user and then executes the build scrip.
It creates a 'chip' user and 'chip' group to run the API service.
It deploys the 'chip-api' service into the /opt/chip/chip_api folder
It deploys the 'chip-app' into the NGINX 'html' folder, overwriting the default pages.
It adds some proxy and logging configurations into the nginx/default.d/ and nginx/conf.d folders respectively.  Those are found in /etc/nginx.
It then starts the 'chip-api' and 'nginx' services.

Caveats

This creates a Centos7 server running the CHIP application. It is a run-once per server kind of script, though parts could be extracted for repeat runs on existing server. It is not necessarily locked down completely for production use (no setup of https, firewall, port blocking etc).  It also adds necessary tools to build and deploy the CHIP application from source. It does not do any setup for Azure or any other cloud environment.

P.S. - script will be checked in to repo in docs/deployment/centos7




The build of the API should result in a chip_api.tar.gz file that is then extracted into the location you reference. Check around line 149 of the setup script to get a hint as to the location of the chip_api.tar.gz file after you build.

Good work on the SELinux. I’m not certain that the /tmp folder is a critical folder… I just needed a temporary place to clone the repo for the setup script. But if it works…

Back to the api… building the api should result in the ?.tar.gz file… which can then be extracted into the path you reference. The API runs as a systemd service… the end of the setup.sh script shows how to start the service. As a practice, you should stop the service, extract the files, run any seeds or migrations added, then start the service.

Automate it. Automation is your friend.