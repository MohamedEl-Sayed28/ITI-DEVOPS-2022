#! /bin/bash

validate_input ()
{
  typeset valid=1;
  if [[ $colKey == "pk" ]]
  then
    if [[ $input == "" ]]
    then
      echo -e "invalid input, primary key doesn't accept null ❌" 
      valid=0
    elif [[ `awk -F: '{if ( $1 == "'"$input"'" ) print 0; }' db_list/$connected_db/tables/$selected_table` == 0 ]]
    then 
      echo -e "invalid input, primary key must be uniqe ❌"
      valid=0
    fi
  fi

  if [[ $colType == "int" && $input != "" ]]
  then
    if ! [[  "$input" =~ ^[0-9]*$ ]]
    then
      echo "invalid data type please enter intger Value ❌"
      valid=0
    fi
  fi

  if [ $valid -eq 1 ]
  then
    echo "valid"
  fi
}

clear

echo "+---------------------------------------------+"
echo "|                                             |"
echo "|  You are about to insert data into tables   |"
echo "|                                             |"
echo "+---------------------------------------------+"
echo " --> Inserting into $selected_table 🔌"
echo "***********************************************"


seperator=":"
row=""
for (( i=1; i<=$no_of_cols; i++ ))
do
  colName=`awk -F: 'NR=='$i'{print $1}' db_list/$connected_db/meta/$selected_table`
  colType=`awk -F: 'NR=='$i'{print $2}' db_list/$connected_db/meta/$selected_table`
  colKey=`awk -F:  'NR=='$i'{print $3}' db_list/$connected_db/meta/$selected_table`

  #get data from user 
  echo -e "Enter $colName ($colType) Value:"         
  read input

  while [[ `validate_input` != "valid" ]]
  do 
    validate_input    
    #get data from user 
    echo -e "Enter $colName ($colType) Value:"         
    read input 
  done

  if [[ $i != $no_of_cols ]]; 
  then
    row="${row}$input$seperator"
  else	
    row="${row}$input"
  fi

done 
echo $row >> db_list/$connected_db/tables/$selected_table

echo "Data inserted Successfully ✅ "
echo "***********************************************"

end_selection "Inseret another row" insert_into_table.sh