#!/usr/bin/env bash

run_service()
{
    service $1 start
    if [ $? -ne 0 ]; then
        exit 1
    fi
}

# Wait for MySQL...
counter=1
while ! mysql -h mysql -ugazelle -ppassword -e "show databases;" > /dev/null 2>&1; do
    sleep 1
    counter=$((counter + 1))
    if [ $((counter % 20)) -eq 0 ]; then
        mysql -h mysql -ugazelle -ppassword -e "show databases;"
        >&2 echo "Still waiting for MySQL (Count: ${counter})."
    fi;
done

# Setup cron
echo "Setting up cron..."
run_service cron
crontab /srv/crontab

# Start Ocelot
echo "Starting ocelot..."
./ocelot
tail -f /tmp/ocelot.log