#!/bin/bash

clear

# to try agin if user make an error 
function try_again
{
    select option in 'Try agin ?' 'Back'
    do 
        case $option in
            'Try agin ?') . ./assets/$1 ;;
            'Back') . ./assets/table_selected.sh ;;
            *) echo "NOT valid option ❌" ;;
        esac
    done
}

# to render the menu after scrept ends 
# you have to send the first option as a first arg and the script you want to run as the second arg
function end_selection
{
    select option in "$1" 'Back' 'Back to connected database' 'Exit'
    do
        case $option in
            "$1") . ./assets/$2 ;;
            'Back') . ./assets/table_selected.sh ;;
            'Back to connected database') . ./assets/db_connected.sh ;;
            'Exit') ex ;;
            *) echo "NOT valid option ❌" ;;
        esac
    done
}

# to get the column number by it's name
# pass the column name as first arg
function get_col_no
{
    awk -F: -v col_n=$1 '
    { 
        if ($1 == col_n) 
        {
            print NR 
        } 
    }' db_list/$connected_db/meta/$selected_table
}

function get_col_type
{
    awk -F: -v col_n=$1 '
    { 
        if ($1 == col_n) 
        {
            print $2 
        } 
    }' db_list/$connected_db/meta/$selected_table
}

function is_col_not_exist
{
    if [[ `cat db_list/$connected_db/meta/$selected_table | cut -d: -f1 | grep -w $1 | wc -l` -eq 0 ]]
    then
        echo true
    else
        echo false
    fi
}


no_of_cols=`cat db_list/$connected_db/meta/$selected_table | wc -l`
no_of_rows=`cat db_list/$connected_db/tables/$selected_table | wc -l`
pk_col=`head -1 db_list/$connected_db/meta/$selected_table | cut -d: -f1`

echo "+----------------------------------------+"
echo "|                                        |"
echo "|      ✅ Successfully Selected ✅       |"
echo "|                                        |"
echo "+----------------------------------------+"
echo " --> Selected $selected_table 🔌"
echo "******************************************"

select option in "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "Back" "Exit"
    do
        case $option in
           "Insert into Table") . ./assets/insert_into_table.sh
                ;;
            "Select From Table") . ./assets/select_from_table.sh
                ;;
            "Delete From Table") . ./assets/delete_from_table.sh
                ;;
            "Update Table") . ./assets/update_table.sh
                ;;
            "Back") . ./assets/db_connected.sh
                ;;
            "Exit") ex
                ;;
            *) echo "NOT valid option ❌" 
                ;;
        esac    
done