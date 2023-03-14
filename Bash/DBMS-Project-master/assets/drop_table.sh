#!/bin/bash

clear

echo "+----------------------------------------+"
echo "|                                        |"
echo "|  You are about to delete Table.        |"
echo "|   🚨 NOT allowed special characters    |"
echo "|   🚨 NOT allowed to start with number  |"
echo "|   🚨 Start with char or _ only         |"
echo "|                                        |"
echo "+----------------------------------------+"
echo " --> delete table from $connected_db"
echo "******************************************"

read -p "Please enter the table name: " t_name

# check if the name is valid
while [ `is_vaild_name "$t_name"` == false ]
do
    echo "NOT valid Table name ❌"
    read -p "Please try again: " t_name 
done

# check if table is exists or not
if [ ! -f "db_list/$connected_db/tables/$t_name" ]
then
    echo "$t_name table is not exsist ❌"
    try_again drop_table.sh 
fi

# ask the user if 
read -n1 -p "Are you sure to delete $t_name ? yY|nN: " ans
echo

# ensure the user input is Y or N
until [[ ${ans^^} == 'Y' || ${ans^^} == 'N' ]]
do
    echo "NOT vaild input ❌"
    read -n1 -p "Try again: " ans
    echo
done

if [ ${ans^^} == 'Y' ]
then
    
    rm -r db_list/$connected_db/tables/$t_name
    rm -r db_list/$connected_db/meta/$t_name

    echo "$t_name has been successfully deleted ✅"
    echo "******************************************"

else
    echo "Cancelled ❌"
    echo "******************************************"
fi


end_selection "Delete another table" drop_table.sh
