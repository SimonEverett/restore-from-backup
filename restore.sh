#!/bin/bash
# Loading project .env
export $(cat .env | xargs) > /dev/null

#Checking to see if the.env exist we need
if [ -z "$PRODUCITON_URL" ]; then
    echo "BACKUP_BUCKET is not set"
    exit 1
fi

if [ -z "$BACKUP_BUCKET" ]; then
    echo "BACKUP_BUCKET is not set"
    exit 1
fi

if [ -z "$DATABASE_HOST" ]; then
    echo "DATABASE_HOST is not set"
    exit 1
fi


if [ -z "$DATABASE_USER" ]; then
    echo "DATABASE_USER is not set"
    exit 1
fi
if [ -z "$DATABASE_NAME" ]; then
    echo "DATABASE_NAME is not set"
    exit 1
fi
if [ -z "$DATABASE_PASSWORD" ]; then
    echo "DATABASE_PASSWORD is not set"
    exit 1
fi

# Working out our home DIR
devopsDir=`echo $BASH_SOURCE | sed 's/restore.sh//g'`

# Checking to make sure user had all of the software dependency
ansible-playbook $devopsDir/restore.yml --extra-vars '{"mode":"dep_check"}'

PS3="Select backup to restore: "

# Pulling list of packup files
s3=$(aws s3 ls $BACKUP_BUCKET --recursive --profile=effectReadOnlyBackups | awk '{print $4}' |tr '\n' ' ')

select files in ${s3}
do
    echo "Selected number: $REPLY"
    echo "\033[33mAre you sure you want to overwrite your local '$DATABASE_NAME'\033[0m"
    read -p "$files (y/n)?" -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi
    ansible-playbook $devopsDir/restore.yml --extra-vars '{"restore_db":"'$files'","new_site": "'$APP_URL'","old_site": "'$PRODUCITON_URL'","db_host": "'$DATABASE_HOST'","db_user": "'$DATABASE_USER'","db_name": "'$DATABASE_NAME'","db_password": "'$DATABASE_PASSWORD'" }'
    exit 1
done
