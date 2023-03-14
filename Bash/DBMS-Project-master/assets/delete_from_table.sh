#!/bin/bash

clear

echo "+----------------------------------------+"
echo "|                                        |"
echo "|      🗑  Deleting from Database 🗑       |"
echo "|                                        |"
echo "+----------------------------------------+"
echo " --> Deleting from $selected_table 🔌"
echo "******************************************"


# get the colmun name from the user
read -p "Please enter the primary key value: " pk
while [ "$pk" == "" ]
do
    echo "NOT valid input ❌"
    read -p "Please try again: " pk
done

# check if pk is exists or not
if [ `cat db_list/$connected_db/tables/$selected_table | cut -d: -f1 | grep -w "$pk" | wc -l` -eq 0 ]
then
    echo "$pk NOT exist ❌"
    try_again delete_from_table.sh
fi

# ask the user if 
read -n1 -p "Are you sure to delete $pk ? yY|nN: " ans
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
    
    awk -F: -v val="$pk" '!($1 == val)' db_list/$connected_db/tables/$selected_table > db_list/$connected_db/tables/tmp && mv db_list/$connected_db/tables/tmp db_list/$connected_db/tables/$selected_table

    echo "$pk has been successfully deleted ✅"
    echo "******************************************"

else
    echo "Cancelled ❌"
    echo "******************************************"
fi

end_selection "Delete another record" delete_from_table.sh