#!/bin/sh

bin/console.sh -b "CONNECT $DB_NAME; BACKUP DATABASE; SLEEP 1000;"
echo
