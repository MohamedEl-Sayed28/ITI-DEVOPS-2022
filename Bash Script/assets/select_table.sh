#!/bin/bash

clear

echo "+----------------------------------------+"
echo "|                                        |"
echo "|  You are about to select certain table |"
echo "|   🚨 NOT allowed special characters    |"
echo "|   🚨 NOT allowed to start with number  |"
echo "|   🚨 Start with char or _ only         |"
echo "|                                        |"
echo "+----------------------------------------+"
echo
echo "******************************************"

read -p "Please enter the table name: " selected_table

# check if the name is valid
while [ `is_vaild_name "$selected_table"` == false ]
do
    echo "NOT valid table name ❌"
    read -p "Please try again: " selected_table 
done

# check if table is exists or not
if [ ! -f db_list/$connected_db/tables/$selected_table ]
then
    echo "$selected_table table NOT exist ❌"
    try_again select_table.sh 
fi

. ./assets/table_selected.sh