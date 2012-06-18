#!/bin/bash

# Note: Script documentation has been moved to README.md
echo "Starting backup of gocongress data" | logger

# Configuration
backupdir="/Users/jared/git/usgo/gocongress/backup"
curdate=`date "+%Y-%m-%d-%H-%M"`

# Load RVM because we don't want to use the system ruby ..
if [[ -s ~/.rvm/scripts/rvm ]]; then
  . ~/.rvm/scripts/rvm
else
  echo "Fatal: Cannot find RVM" | logger
  exit 1
fi

# .. we want to use the project's ruby (and gemset).
# Therefore, cd into the backup dir causing its .rvmrc to run
cd $backupdir
echo "Heroku gem version is: $(heroku version)" | logger

# Old method: Use taps to pull into a sqlite db
heroku db:pull sqlite://$backupdir/$curdate.db --app gocongress --confirm gocongress

# New method: Use pgbackups to pull into a psql dump
echo "Starting pgbackups capture" | logger
heroku pgbackups:capture --app gocongress | logger
bkp_url=`heroku pgbackups:url --app gocongress`
curl -o $backupdir/$curdate.dump $bkp_url
du -h $backupdir/$curdate.dump | logger

# stick a fork in it, we are done
echo "Done with backup of gocongress data" | logger
