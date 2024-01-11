# !/bin/bash
# Sciprt Name: addRecord.sh
# Author: Kate Molony
# Programme: written to add record of speakers at a confrence 
# to the file contactdetails.txt

#check if file exists, if not make copy of file
if [ -a ~/contactdetails.txt ]; 

then
#file path must be established as a variable
	file_path="contactdetails.txt"

else

        cp contactdetails.txt contactdetails.bak
	file_path="contactdetails.bak"

fi

# Define colors
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Display the title and description in cyan
echo "======================================"
echo -e "${CYAN}              Add Record${NC}"
echo "======================================"
echo "Welcome to the Tech Conference Catalogue."
echo "Here, you can add a new record to the catalogue."
echo ""
echo "Type q and press enter to return to the main menu"
count=0
while [ $count -lt 6 ]
do
   if [ $count -eq 0 ]
# Don't forget that in an if statement,  
#we need a space after the opening and the closing brace>
   then

echo -e "\nPlease enter confrence talk details"

#loop added to repeat if input is unaccepted
while true; do
read -p "Enter speakers first name: " fName

    if [[ "$fName" == [qQ] ]]; then
	echo ""
	echo "Returning to main menu."
        exit 0
    fi

	#must not be blank or contain a number
  if [[ ! -z "$fName" && ! "$fName" =~ [0-9] ]]; then
    count=$((count+1))
    break # break the loop once input is accepted
  else
    echo "Warning: You cannot enter a blank name or a name with numbers."
  fi
done

while true; do
read -p "Enter speakers last name: " lName

    if [[ "$lName" == [qQ] ]]; then
        echo ""
	echo "Returning to main menu."
        exit 0
    fi

  if [[ ! -z "$lName" && ! "$lName" =~ [0-9] ]]; then
    count=$((count+1))
    break # break the loop once input is accepted
  else
    echo "Warning: You cannot enter a blank name or a name with numbers."
  fi
done

while true; do
read -p "Enter a valid irish mobile number: " user_input

    if [[ "$user_input" == [qQ] ]]; then
        echo ""
        echo "Returning to main menu."
        exit 0
    fi

# Remove any whitespace from the input
phone=$(echo "$user_input" | tr -d '[:space:]')

# Check if the input is ten characters and the first two are '08'
if [[ ${#phone} -eq 10 && ${phone:0:2} == "08" && "$phone" =~ ^[0-9]+$ ]]; 
     then
	echo "Valid input: $phone"
        count=$((count+1))
	break
      else
	echo "Invalid input. Please enter a ten-digit number starting with '08'."
      fi
done

while true; do
read -p "Please enter a time in 24-hour format (HH:MM): " talkTime

    if [[ "$talkTime" == [qQ] ]]; then
        echo ""
        echo "Returning to main menu."
        exit 0
    fi

# Define a pattern to validate the input
pattern="^([01]?[0-9]|2[0-3]):[0-5][0-9]$"

# Check if the user input matches the pattern
if [[ $talkTime =~ $pattern ]]; then

	echo "You entered a valid 24-hour time: $talkTime"
	count=$((count+1))
	break
else
    echo "Invalid input. Please enter a time in 24-hour format (HH:MM)."
fi

done

while true; do
read -p "Enter the title of the talk: " title

    if [[ "$title" == [qQ] ]]; then
        echo ""
        echo "Returning to main menu."
        exit 0
    fi

	#cannot enter a blank title
      if ! [ -z "${title}" ]
      then
        count=$((count+1))
	break
      else
        echo "Warning: You cannot enter a blank title"
      fi
done

while true; do
  read -p "Choose between 5 venues (GY101, GY102, GY103, GY104, GY105): " venue
  venue=${venue^^}  # Convert to uppercase

    if [[ "$venue" == [qQ] ]]; then
        echo ""
	echo "Returning to main menu."
        exit 0
    fi

	# input must match The 5 options
  case "$venue" in
    GY101|GY102|GY103|GY104|GY105)
      count=$((count+1))
      break
      ;;
    *)
      echo "Warning: Please enter a valid venue (GY101, GY102, GY103, GY104, GY105)."
      ;;
  esac

done

   fi

done

if [ $count -eq 6 ]
then
# This re-displays the data entered so the user can confirm.
echo "----------- Entered Data ---------------------------------------------------------------"
echo $fName" ; "$lName" ; "$phone" ; "$talkTime" ; "$title" ; "$venue" ; " 
echo "----------------------------------------------------------------------------------------"

read -p "Do you want to edit the speaker's details? (y/n): " edit_choice
#read edit_choice

    if [[ "$edit_choice" == [qQ] ]]; then
        echo ""
        echo "Returning to main menu."
        exit 0
    fi

# Ensure the choice is lowercase for easier comparison
edit_choice=$(echo "$edit_choice" | tr '[:upper:]' '[:lower:]')

if [[ $edit_choice == "y" ]]; then
echo "Calling edit_script.sh with arguments: $fName $lName $phone $talkTime $title $venue"
    # Call the edit script and pass the variables
	./editRecord.sh "$fName" "$lName" "$phone" "$talkTime" "$title" "$venue"
# pass edited data from txt file back into script
edited_data=$(<edited_data.txt)

    # Update the variables with the edited data
    IFS=';' read -r -a edited_fields <<< "$edited_data"
    fName="${edited_fields[0]}"
    lName="${edited_fields[1]}"
    phone="${edited_fields[2]}"
    talkTime="${edited_fields[3]}"
    title="${edited_fields[4]}"
    venue="${edited_fields[5]}"

fi

echo -n "Are you sure you want to add this speaker (y/n) :"

read answer

    if [[ "$answer" == [qQ] ]]; then
        echo ""
        echo "Returning to main menu."
        exit 0
    fi

if [[ "$answer"  ==  "y" || "$answer" == "Y" ]]
then
 
# Give a unique identitfication number to the entered data in the file
# from the line number add 1
count=$(awk '{print $1}' "$file_path" | wc -l)
result=$((count + 1))

  echo "-----------------------------------------------------------------------------------------"
 
  echo "-----------------------------------------------------------------------------------------"
   echo $fName" ; "$lName" ; "$phone" ; "$talkTime" ; "$title" ; "$venue" ; "   "added successfully"
   echo "----------------------------------------------------------------------------------------"
   echo $result" ; "$fName" ; "$lName" ; "$phone" ; "$talkTime" ; "$title" ; "$venue" ; "   >> "$file_path"
 

	else

   echo "Attendant has not been added"

	fi
fi

echo ""
read -p "Do you want to add another speaker? (y/n) " answer
echo ""

case $answer in
    [yY] | [yY][eE][sS] )
        ./addRecord.sh;; 
    [nN] | [nN][oO] )
        echo "Returning to main menu."
        ./menu.sh
        echo;;
    *) echo exit;;
esac

