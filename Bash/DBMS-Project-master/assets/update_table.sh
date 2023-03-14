#!/bin/bash

function validate_pk_col
{
    if [ "$pk" == "" ]
    then
        echo "NOT valid input ❌"

    # check if value of pk is exists or not
    elif [ `cat db_list/$connected_db/tables/$selected_table | cut -d: -f1 | grep -w "$pk" | wc -l` -eq 0 ]
    then
        echo "$pk NOT exist ❌"

    else 
        echo "valid"
    fi
}

function validate_col_name
{
    # check if the name is valid
    if [ `is_vaild_name "$col_n"` == false ]
    then
        echo "NOT valid column name ❌"

    # check if column is exists or not
    elif [ `is_col_not_exist $col_n` == true ]
    then
        echo "$col_n column NOT exist ❌"
    
    # check if column is pk
    elif [ $col_n == $pk_col ]
    then
        echo "NOT allowed to update primary key column ❌"
    else
        echo "valid"
    fi
}


function render_banner
{
    clear

    echo "+----------------------------------------+"
    echo "|                                        |"
    echo "|          📝  Updating table 📝         |"
    echo "|                                        |"
    echo "+----------------------------------------+"
    echo " --> Updating $selected_table 🔌"
    echo "******************************************"
}

render_banner

function update_by_pk
{
    render_banner

    # get the pk from the user
    read -p "Please enter the primary key value: " pk

    while [[ `validate_pk_col` != "valid" ]]
    do
        validate_pk_col
        ask_loop table_selected.sh
        read -p "Try again: " pk
    done    

    # get the colmun name from the user
    read -p "Please enter the column name: " col_n

    # validate the data of user
    while [[ `validate_col_name` != "valid" ]]
    do
        validate_col_name
        ask_loop table_selected.sh
        read -p "Try again: " col_n
    done    

    # get the value of column
    read -p "Please enter the new vaule: " value

    col_type=`get_col_type $col_n`
    
    if [[ $col_type == "int" && "$value" != "" ]]
    then
        # ensure the user input is digit
        while [[ ! "$value" =~ ^['0-9']+$ ]]
        do
            echo "This column accept integers only ❌"
            ask_loop table_selected.sh
            read -p "Try again: " value
        done
    fi

    # get the column number
    col_no=`get_col_no $col_n`

    awk -F: -v col_no=$col_no  -v val="$value" -v pk=$pk '
    BEGIN{FS=OFS=":"}
    {
        if ($1 == pk)
        {
            $col_no = val;
        }
        print $0
    }' db_list/$connected_db/tables/$selected_table > db_list/$connected_db/tables/tmp && mv db_list/$connected_db/tables/tmp db_list/$connected_db/tables/$selected_table 

    echo "$pk has been successfully updated ✅"
    echo "******************************************"

    end_selection "Update another record" update_table.sh
}


function update_by_col
{
    render_banner

    # get the colmun name from the user
    read -p "Please enter the column name: " col_n

    # validate the data of user
    while [[ `validate_col_name` != "valid" ]]
    do
        validate_col_name
        ask_loop table_selected.sh
        read -p "Try again: " col_n
    done 

    # get the column number
    col_no=`get_col_no $col_n`

    # get the column datatype
    col_type=`get_col_type $col_n`

    # get the colmun name from the user
    read -p "Please enter the old value: " ovalue

    # search the old value in the column name provided
    while [[ `awk -F: -v ovalue="$ovalue" '{ if ($'$col_no' == ovalue) { print 1; exit;} }' db_list/$connected_db/tables/$selected_table` != 1 ]]
    do
        echo "there is no result matchs value: \"$ovalue\""
        ask_loop table_selected.sh
        read -p "Try again: " ovalue
    done
    
    # get the value of column
    read -p "Please enter the new vaule: " value

    if [[ $col_type == "int" && "$value" != "" ]]
    then
        # ensure the user input is digit
        while [[ ! "$value" =~ ^['0-9']+$ ]]
        do
            echo "This column accept integers only ❌"
            ask_loop table_selected.sh
            read -p "Try again: " value
        done
    fi

    awk -F: -v col_no=$col_no  -v oval="$ovalue" -v nval="$value" '
    BEGIN{FS=OFS=":"}
    {
        if ($col_no == oval)
        {
            $col_no = nval;
        }
        print $0
    }' db_list/$connected_db/tables/$selected_table > db_list/$connected_db/tables/tmp && mv db_list/$connected_db/tables/tmp db_list/$connected_db/tables/$selected_table 

    echo "$pk has been successfully updated ✅"
    echo "******************************************"

    end_selection "Update another record" update_table.sh    
}


select option in "Update by primary key" "Update by column value" "Back" "Exit"
do
    case $option in
        "Update by primary key") update_by_pk
            ;;
        "Update by column value") update_by_col
            ;;
        "Back") . ./assets/table_selected.sh
            ;;
        "Exit") ex
            ;;
        *) echo "NOT valid option ❌" 
            ;;
    esac    
done
