#!/bin/bash
# shopt -s extglob

clear

echo "+----------------------------------------+"
echo "|                                        |"
echo "|  You are about to crate new Database   |"
echo "|   🚨 NOT allowed special characters    |"
echo "|   🚨 NOT allowed to start with number  |"
echo "|   🚨 Start with char or _ only         |"
echo "|                                        |"
echo "+----------------------------------------+"
echo
echo "******************************************"

read -p "Please enter the database name: " db_name

# check if the name is valid
while [ `is_vaild_name "$db_name"` == false ]
do
    echo "you can not use this name for your database ❌"
    read -p "Please try again: " db_name 
done

# check if data base is exists or not
if [ -d db_list/$db_name ]
then
    echo "this database is already exsist ❌"
    try_again create_db.sh 
fi


mkdir -p db_list/$db_name db_list/$db_name/tables db_list/$db_name/meta;

echo "$db_name has been successfully created ✅"
echo "******************************************" 

end_selection 'Create another database' create_db.sh