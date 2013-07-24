#!/bin/bash

# Note: Script documentation has been moved to README.md
echo "Starting backup of gocongress data"

# Configuration
backupdir="/home/jared/git/usgo/gocongress/backup"
curdate=`date "+%Y-%m-%d-%H-%M"`

# .. we want to use the project's ruby (and gemset).
# Therefore, cd into the backup dir causing its .rvmrc to run
cd $backupdir
echo "Heroku gem version is: $(heroku version)"

# Use pgbackups to pull into a psql dump
# capture --expire automatically deletes oldest backup
echo "Starting pgbackups capture"
heroku pgbackups:capture --expire --app gocongress
bkp_url=`heroku pgbackups:url --app gocongress`
curl -o $backupdir/$curdate.dump $bkp_url
du -h $backupdir/$curdate.dump

# stick a fork in it, we are done
echo "Done with backup of gocongress data"

