#!/bin/sh

## Backup on shutdown
trap 'kill $PID && ./backup.sh' INT QUIT TERM

## Restore database if backup exists
./restore.sh

## Start database server
bin/server.sh "-Darcadedb.server.rootPasswordPath=$DB_PASS" "-Darcadedb.server.defaultDatabases=$DB_NAME[]" &

PID="$!"

## Keep alive
wait $PID
