gocongress.org backup scripts
====

A nightly backup for gocongress.org, using launchd, bash, and
heroku pgbackups.

1. Install `org.gocongress.backup.plist` in `/Library/LaunchDaemons`
1. `launchctl load /Library/LaunchDaemons/org.gocongress.backup.plist`

To test this script through launchd, run:

    sudo launchctl start org.gocongress.backup

See Also
----

http://singlebrook.com/blog/scheduling-a-shell-script-with-launchd
