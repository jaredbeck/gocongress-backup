#!/bin/bash
set -e

# Note: Script documentation has been moved to README.md
echo "Starting backup of gocongress data" | logger

# Configuration
heroku_bin='/usr/bin/heroku'
backup_root="/Users/jared/git/usgo/gocongress/backup"
month_stamp=`date "+%Y-%m"`
curdate=`date "+%Y-%m-%d-%H-%M"`

# Make sure Heroku toolbelt is installed
if [ ! -x $heroku_bin ]; then
  echo "Fatal: File not executable: $heroku_bin" | logger
  exit 1
fi

echo "Heroku version is: $(heroku version)" | logger

# Make the monthly dir, if needed
backup_dir="$backup_root/$month_stamp"
if [ ! -d $backup_dir ]; then
  mkdir $backup_dir
fi

# Use pgbackups to pull into a psql dump
# `capture --expire` automatically deletes oldest backup
echo "Starting pgbackups capture" | logger
heroku pgbackups:capture --expire --app gocongress | logger
bkp_url=`heroku pgbackups:url --app gocongress`
dump_path="$backup_dir/$curdate.dump"
curl -o $dump_path $bkp_url
du -h $dump_path | logger

# stick a fork in it, we are done
echo "Done with backup of gocongress data" | logger
