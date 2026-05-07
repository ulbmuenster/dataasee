#!/bin/sh

# Restore database if backup exists
if ls /backup/$DB_NAME/$DB_NAME* 1> /dev/null 2>&1; then
  bin/restore.sh -f file:///backup/$DB_NAME/`ls -r /backup/$DB_NAME | head -1` -d databases/$DB_NAME -o true
fi

# Start database server
bin/server.sh $DB_OPTS "-Darcadedb.server.rootPasswordPath=$DB_PASS" "-Darcadedb.server.defaultDatabases=$DB_NAME[]" "-Darcadedb.redis.defaultDatabase=$DB_NAME"
