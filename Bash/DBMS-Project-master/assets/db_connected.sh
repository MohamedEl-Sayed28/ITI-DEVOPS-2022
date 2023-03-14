#!/bin/bash

clear

# to try agin if user make an error 
function try_again
{
    select option in 'Try agin ?' 'Back'
    do 
        case $option in
            'Try agin ?') . ./assets/$1 ;;
            'Back') . ./assets/db_connected.sh ;;
            *) echo "NOT valid option ❌" ;;
        esac
    done
}

# to render the menu after scrept ends 
# you have to send the first option as a first arg and the script you want to run as the second arg
function end_selection
{
    select option in "$1" 'Back' 'Back to main menu' 'Exit'
    do
        case $option in
            "$1") . ./assets/$2 ;;
            'Back') . ./assets/db_connected.sh ;;
            'Back to main menu') . ./run.sh ;;
            'Exit') ex ;;
            *) echo "NOT valid option ❌" ;;
        esac
    done
}

echo "+----------------------------------------+"
echo "|                                        |"
echo "|     ✅ Successfully Connected ✅       |"
echo "|                                        |"
echo "+----------------------------------------+"
echo " --> connected to $connected_db 🔌"
echo "******************************************"

select option in "Create Table" "List Tables" "Drop Table" "Select Table" "Back to main menu" "Exit"
    do
        case $option in
            "Create Table") . ./assets/create_table.sh
                ;;
            "List Tables") . ./assets/list_tables.sh
                ;;
            "Drop Table") . ./assets/drop_table.sh
                ;;
            "Select Table") . ./assets/select_table.sh
                ;;
            "Back to main menu") . ./run.sh
                ;;
            "Exit") ex
                ;;
            *) echo "NOT valid option ❌" 
                ;;
        esac    
done