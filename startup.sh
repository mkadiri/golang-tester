#!/bin/sh

echo "--- Check if database is running"

while ! mysqladmin ping -h $MYSQL_HOST -u $MYSQL_USER -P $MYSQL_PORT --password=$MYSQL_PASSWORD --silent; do
    echo "Waiting for $MYSQL_HOST:$MYSQL_PORT to wake up"
    sleep 5
done

echo "--- Create database if one does not exist"
mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER --password=$MYSQL_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE"

echo "--- Run migrations"
/migrate -path /migrations -database "mysql://$MYSQL_USER:$MYSQL_PASSWORD@tcp($MYSQL_HOST:$MYSQL_PORT)/$MYSQL_DATABASE" up

echo "--- Run fixtures for dev environment"
mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER --password=$MYSQL_PASSWORD -e "USE $MYSQL_DATABASE"

for file in /dev-fixtures/*; do
    echo "Importing fixtures contained in $file"
    mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER --default-character-set=utf8 --password=$MYSQL_PASSWORD --database=$MYSQL_DATABASE < $file
done

cd $PROJECT_URL
go get

echo "--- Run tests"
go test -v ./...

echo "Finished"