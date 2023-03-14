#!/bin/bash

clear

echo "+----------------------------------------+"
echo "|                                        |"
echo "|  You are about to connect to Database  |"
echo "|   🚨 NOT allowed special characters    |"
echo "|   🚨 NOT allowed to start with number  |"
echo "|   🚨 Start with char or _ only         |"
echo "|                                        |"
echo "+----------------------------------------+"
echo
echo "******************************************"

read -p "Please enter the database name: " connected_db

# check if the name is valid
while [ `is_vaild_name "$connected_db"` == false ]
do
    echo "NOT valid database name ❌"
    read -p "Please try again: " connected_db 
done

# check if data base is exists or not
if [ ! -d db_list/$connected_db ]
then
    echo "$connected_db database NOT exist ❌"
    try_again connect_db.sh 
fi


. ./assets/db_connected.sh