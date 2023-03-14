#!/usr/bin/bash

clear

echo "+----------------------------------------+"
echo "|                                        |"
echo "|  You are about to delete Database      |"
echo "|   🚨 NOT allowed special characters    |"
echo "|   🚨 NOT allowed to start with number  |"
echo "|   🚨 Start with char or _ only         |"
echo "|                                        |"
echo "+----------------------------------------+"
echo
echo "******************************************"

read -p "Please enter the database name: " db_name


# check valid name
if [ `is_vaild_name "$db_name"` == true ]
then
    # check if is exist and in current dir
    if [ -d db_list/$db_name  ]
    then

        # ask the user if 
        read -n1 -p "Are you sure to delete $db_name ? yY|nN: " ans
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
            rm -r db_list/$db_name/
            echo "$db_name has been successfully deleted  ✅"
            echo "******************************************" 

        else
            echo "Cancelled ❌"
            echo "******************************************"
        fi        
    else
        echo "$db_name database not exist ❌"
        try_again drop_db.sh
    fi
    
else
    echo "NOT valid database name ❌"
    try_again drop_db.sh
fi

end_selection 'Drop another database' drop_db.sh
