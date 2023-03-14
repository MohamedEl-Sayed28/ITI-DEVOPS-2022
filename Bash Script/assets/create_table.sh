#!/bin/bash

clear

is_col_exist ()
{
    typeset exist=false
    for co in ${cols[@]} 
    do
        if [ `echo $co | cut -d: -f1` == "$1" ]
        then 
            exist=true
            break
        fi
    done
    echo $exist
}


validate_col_name ()
{
    typeset valid=1;

    # check if the name is valid
    if [ `is_vaild_name "$col_name"` == false ]
    then
        echo "you can not use this name for your column ❌"
        valid=0;
       
    # check if the name is exist
    elif [ `is_col_exist $col_name` == true ]
    then
        echo "this name already exist ❌"
        valid=0;
    fi

    if [ $valid -eq 1 ]
    then
        echo "valid"
    fi
}


echo "+----------------------------------------+"
echo "|                                        |"
echo "|  You are about to crate new Table.     |"
echo "|   🚨 NOT allowed special characters    |"
echo "|   🚨 NOT allowed to start with number  |"
echo "|   🚨 Start with char or _ only         |"
echo "|                                        |"
echo "+----------------------------------------+"
echo " --> creating table in $connected_db database"
echo "******************************************"

read -p "Please enter the table name: " t_name

# check if the name is valid
while [ `is_vaild_name "$t_name"` == false ]
do
    echo "you can not use this name for your table ❌"
    read -p "Please try again: " t_name 
done

# check if table is exists or not
if [ -f "db_list/$connected_db/tables/$t_name" ]
then
    echo "$db_name table is already exsist ❌"
    try_again create_table.sh 
fi

# read the number of columns 
read -p "Enter the number of columns at least 2: " no_cols

# ensure the user input is digit
while [[ ! $no_cols =~ ^['0-9']+$ || $no_cols -lt 2 ]]
do
    echo "NOT vaild input ❌"
    read -p "Try again: " no_cols
done

typeset cols[size]

# get columns data from user
for ((i=1; i<=$no_cols; i++))
do
    # get the pk column data
    if [[ $i == 1 ]]
    then 
        read -p "Enter primary key name: " col_name
    else
        read -p "Enter colum no. $i name: " col_name
        
    fi

    while [[ `validate_col_name` != "valid" ]]
    do
        validate_col_name
        read -p "Try again: " col_name
    done

    row="${col_name}:"

    select type in "String" "Integer"
    do
        case $type in 
            "String") row="${row}str:"; break
                ;;
            "Integer") row="${row}int:"; break
                ;;
            *) echo "NOT valid option ❌" 
                ;;
        esac
    done
    

    # add the pk column data if index 1
    if [[ $i == 1 ]]
    then 
        row="${row}pk"
    fi   

    # append the record to the arr
    # echo $row >> db_list/$connected_db/meta/$t_name
    cols[$i]=$row
done

# create required files
touch db_list/$connected_db/tables/$t_name
touch db_list/$connected_db/meta/$t_name

# store meta data for table
for record in ${cols[@]}
do
    echo $record >> db_list/$connected_db/meta/$t_name
done

echo "$t_name has been successfully created ✅"
echo "******************************************"

end_selection "Crate another table" create_table.sh
