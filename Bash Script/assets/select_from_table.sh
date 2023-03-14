#!/bin/bash

clear

echo "+----------------------------------------+"
echo "|                                        |"
echo "|     📖 Selecting from Database 📖      |"
echo "|                                        |"
echo "+----------------------------------------+"
echo " --> Selecting from $selected_table 🔌"
echo "******************************************"

typeset maxs[$no_of_cols]

# to get the max len in each column
for ((i=1; i<=$no_of_cols; i++))
do
    maxcol=`awk -F: -v ind=$i ' BEGIN {max = 0} { if (length($'$i') > max) { max = length($'$i') } } END { print max+3 }' db_list/$connected_db/tables/$selected_table`
    maxhead=`awk -F: -v ind=$i ' BEGIN {max = 0} { if (length($1) > max && NR == '$i') { max = length($1) } } END { print max+3 }' db_list/$connected_db/meta/$selected_table`
    if [ $maxcol -gt $maxhead ]
    then
        maxs[$i]=$maxcol
    else
        maxs[$i]=$maxhead
    fi
done


# to reander the H lines 
function render_line
{
    echo
    for ((i=1; i<=$no_of_cols ; i++)) 
    do
        echo -n "+"
        for ((z=1; z<=${maxs[$i]}; z++)); do echo -n "-"; done
        echo -n "+"
    done
    echo
}

# to print out the data 
function render_data_row
{   
    echo -n "| $1"
    # calc how many space should be printed
    for ((i=1; i<=$2 - `echo $1 | wc -c` ; i++)); do echo -n ' '; done
    echo -n "|"    
}


# to print the column names 
function render_header
{
    echo
    echo "+--------------+ $selected_table +--------------+"
    render_line 
    typeset index=1
    for col_name in `cat db_list/$connected_db/meta/$selected_table | cut -d: -f1`
    do
        render_data_row $col_name ${maxs[$index]}
        index=$((index+1))
    done
    
    render_line 
}


# to print the table is empty
function no_data
{
    echo "+----------------------------------------+"
    echo "|                                        |"
    echo "|          The table is empty            |"
    echo "|                                        |"
    echo "+----------------------------------------+"   
}


validate_col_name ()
{
    typeset valid=1;

    # check if the name is valid
    if [ `is_vaild_name "$col_n"` == false ]
    then
        echo "NOT valid column name ❌"
        valid=0;
       
    # check if the name is exist
    elif [ `is_col_not_exist $col_n` == true ]
    then
        echo "$col_n column NOT exist ❌"
        valid=0;
    fi

    if [ $valid -eq 1 ]
    then
        echo "valid"
    fi
}

# to select all data from the table
function select_all
{
    clear

    # check if the table is empty or not 
    if [ $no_of_rows -gt 0 ]
    then

        # to print the column names 
        render_header

        arr="${maxs[@]}"
        awk -F: -v nor=$no_of_rows -v arr="$arr" '
        BEGIN{split(arr,maxs," ")}
        {
            for (i = 1; i <= NF; i++)
            {
                printf "| "$i;
                for (x=1; x<=maxs[i] - length($i) - 1; x++) { printf " ";}
                printf "|";
            }
            if (nor != NR)
            {
                print ""
            }
        }' db_list/$connected_db/tables/$selected_table

        render_line         
    else
        no_data
    fi
    
    end_selection "Make another selection" select_from_table.sh
}


# to select from the table by value of column
function select_by_val
{
    clear

    # check if the table is empty or not 
    if [ $no_of_rows -gt 0 ]
    then
        
        echo "+----------------------------------------------+"
        echo "|                                              |"
        echo "|  You are about to select from table by value |"
        echo "|     🚨 NOT allowed special characters        |"
        echo "|     🚨 NOT allowed to start with number      |"
        echo "|     🚨 Start with char or _ only             |"
        echo "|                                              |"
        echo "+----------------------------------------------+"
        echo "Avalible columns:-"
        awk -F: '{ print "   --> "$1 }' db_list/$connected_db/meta/$selected_table
        echo "************************************************"

        # get the colmun name from the user
        read -p "Please enter the column name: " col_n

        while [[ `validate_col_name` != "valid" ]]
        do
            validate_col_name
            ask_loop table_selected.sh
            read -p "Try again: " col_n
        done

        # get the value of column
        read -p "Please enter the value would like to search about: " value

        # get the column number
        col_no=`get_col_no $col_n`

        clear

        render_header

        arr="${maxs[@]}"
        
        # start searching
        awk -F: -v nor=$no_of_rows -v col_no=$col_no -v val="$value" -v arr="$arr" '
        BEGIN {
            msg = "   No any data matches the search criteria";
            mat = 0;
            ind = 0;
            split(arr,maxs," ")
        }
        {
            if ($col_no == val)
            {
                mat = 1;

                if (ind > 0)
                {
                    print ""
                }

                for (i = 1; i <= NF; i++)
                {
                    printf "| "$i;
                    for (x=1; x<=maxs[i] - length($i) - 1; x++) { printf " ";}
                    printf "|";
                }

                ind++;
            }
        }
        END { if (mat == 0) { printf msg; }}' db_list/$connected_db/tables/$selected_table

        render_line $no_of_cols
        
    else
        no_data
    fi
    
    end_selection "Make another selection" select_from_table.sh
}

select option in "Select All" "Select by column value" "Back" "Exit"
do
    case $option in
        "Select All") select_all
            ;;
        "Select by column value") select_by_val
            ;;
        "Back") . ./assets/table_selected.sh
            ;;
        "Exit") ex
            ;;
        *) echo "NOT valid option ❌" 
            ;;
    esac    
done

