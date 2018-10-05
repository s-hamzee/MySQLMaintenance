#!/bin/sh

# Author: s-hamzee
# Create Data: Dec 2007
# Description: Simple shell to repair and/or optimze mysql tables automatically, just pass db name, username and password. must be run in localhost



DBNAME=$2
DBUSER=$3
DBPASS=$4

printUsage() {
  echo "Usage: $0"
  echo " --optimize <dbname> <dbuser> <dbpass>"
  echo " --repair <dbname> <dbuser> <dbpass>"
  return
}


doAllTables() {
  # get the table names
  TABLENAMES=`mysql --password=$DBPASS --user=$DBUSER -D $DBNAME -e "SHOW TABLES\G;"|grep 'Tables_in_'|sed -n 's/.*Tables_in_.*: \([_0-9A-Za-z]*\).*/\1/p'`

  # loop through the tables and optimize them
  for TABLENAME in $TABLENAMES
  do
    mysql --password=$DBPASS --user=$DBUSER -D $DBNAME -e "$DBCMD TABLE $TABLENAME;"
  done
}

if [ $# -ne 4 ] ; then
  printUsage
  exit 1
fi

case $1 in
  --optimize) DBCMD=OPTIMIZE; doAllTables;;
  --repair) DBCMD=REPAIR; doAllTables;;
  --help) printUsage; exit 1;;
  *) printUsage; exit 1;;
esac 
