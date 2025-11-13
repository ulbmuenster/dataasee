#!/bin/sh

if ls /backup/$DB_NAME/$DB_NAME* 1> /dev/null 2>&1; then
  bin/restore.sh -f file:///backup/$DB_NAME/`ls -r /backup/$DB_NAME | head -1` -d databases/$DB_NAME -o true
fi
