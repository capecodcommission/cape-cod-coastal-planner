# Prerequisites

### Centos7 server
* 2cpu
* 4 gig RAM
* 30gig storage
* must have access to internet to download packages
* must be accessible on port 80 to browse to app

### Instructions

**!! IMPORTANT !!** You should change the value of the _CHIP_DB_PASSWORD_.  The values is near the top of the script for ease of change.  Also, watch script output... after a few minutes, it will prompt for password for 'shawnmgoulet' to clone the bitbucket repo.  The script does not handle an invalid password well... and you might need to start all over with a new VM if you mistype your password during this step.

1. Log in to VM
1. Become root user (i.e. 'sudo su -')
1. Copy setup script to home folder
1. Make sure setup script is executable
1. Execute script (i.e. './setup.sh')

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

### Caveats

This creates a Centos7 server running the CHIP application. It is a run-once per server kind of script, though parts could be extracted for repeat runs on existing server. It is not necessarily locked down completely for production use (no setup of https, firewall, port blocking etc).  It also adds necessary tools to build and deploy the CHIP application from source. It does not do any setup for Azure or any other cloud environment.