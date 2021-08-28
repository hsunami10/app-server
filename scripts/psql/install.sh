#!/bin/sh

echo "This will install postgres with brew, start a server, create a postgres user and create a new database named \"$POSTGRES_DATABASE_NAME\""

brew install postgres
pg_ctl -D /usr/local/var/postgres start
/usr/local/opt/postgres/bin/createuser -s postgres
psql -U postgres -c "CREATE DATABASE $POSTGRES_DATABASE_NAME"

echo "$POSTGRES_DATABASE_NAME database created!"
