#!/bin/bash
# !/bin/bash
# Sciprt Name: editRecord.sh
# Author: Kate Molony
# Programme: Allows user to edit the record they wanted to add

# Define colors
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""
echo -e ">>>>${CYAN}You are now editing input${NC}<<<<"
echo "type q to cancel editing and return to old input"
echo ""

# Accept the variables from the main script
fName=$1
lName=$2
phone=$3
talkTime=$4
title=$5
venue=$6

# Display the entered data
echo "----------- Entered Data ---------------------------------------------------------------"
echo "First Name: $fName"
echo "Last Name: $lName"
echo "Phone: $phone"
echo "Talk Time: $talkTime"
echo "Title: $title"
echo "Venue: $venue"
echo "----------------------------------------------------------------------------------------"

    # Menu for editing fields
    echo -e "\nMenu for Editing Fields:"
    echo "1. Edit First Name"
    echo "2. Edit Last Name"
    echo "3. Edit Phone"
    echo "4. Edit Talk Time"
    echo "5. Edit Title"
    echo "6. Edit Venue"
    echo "7. Save and Exit"

    while true; do
        read -p "Enter your choice: " choice

        case $choice in
            1) while true; do
		read -p "Enter new First Name: " fName 

    		if [[ "$fName" == [qQ] ]]; then
        	echo ""
        	echo "Cancelling editing."
        	exit
    		fi


		if [[ ! -z "$fName" && ! "$fName" =~ [0-9] ]]; then

		break 2

		else
		echo "Invalid input."

		fi
		done
		;;
            2) while true; do
		read -p "Enter new Last Name: " lName 

                if [[ "$lName" == [qQ] ]]; then
                echo ""
                echo "Cancelling editing."
                exit
                fi

                if [[ ! -z "$lName" && ! "$lName" =~ [0-9] ]]; then

                break 2

                else
                echo "Invalid input."

                fi
                done
                ;;

            3) while true; do
		read -p "Enter new Phone: " phone 

                if [[ "$phone" == [qQ] ]]; then
                echo ""
                echo "Cancelling editing."
                exit
                fi

	# Check if the input is ten characters and the first two are '08'
		if [[ ${#phone} -eq 10 && ${phone:0:2} == "08" && "$phone" =~ ^[0-9]+$ ]]; 
		then
        	echo "Valid input: $phone"

		break 2

		else
        	echo "Invalid input. Please enter a ten-digit number starting with '08'."

		fi

		done
		;;

            4) 
            while true; do
                read -p "Enter new Talk Time (HH:MM): " talkTime

                if [[ "$talkTime" == [qQ] ]]; then
                echo ""
                echo "Cancelling editing."
                exit
                fi

                # Define a regular expression pattern to validate the input
                pattern="^([01]?[0-9]|2[0-3]):[0-5][0-9]$"

                # Check if the user input matches the pattern
                if [[ $talkTime =~ $pattern ]]; then
                    echo "You entered a valid 24-hour time: $talkTime"
                    break 2
                else
                    echo "Invalid input. Please enter a time in 24-hour format (HH:MM)."
                fi
            done
            ;;

            5) while true; do
		 read -p "Enter new Title: " title 

                if [[ "$title" == [qQ] ]]; then
                echo ""
                echo "Cancelling editing."
                exit
                fi

        	#cannot enter a blank title
      		if ! [ -z "${title}" ]
      		then

        	break 2

		else

		echo "Warning: You cannot enter a blank title"

		fi

		done
		;;

            6) while true; do
		read -p "Enter new Venue: " venue 

		venue=${venue^^}  # Convert to uppercase

                if [[ "$venue" == [qQ] ]]; then
                echo ""
                echo "Cancelling editing."
                exit
                fi

		# input must match The 5 options
		if [[ ! -z "${venue}" && ( "${venue}" == "GY101" || "${venue}" == "GY102" || "${venue}" == "GY103" || "${venue}" == "GY104" || "${venue}" == "GY105" ) ]]; 

                then

		break 2

		else

      		echo "Warning: Please enter a valid venue (GY101, GY102, GY103, GY104, GY105)."

		fi
		done
		;;

            7) break ;;
            *) echo "Invalid choice. Please try again." ;;

        esac
    done

# This re-displays the data entered so the user can confirm.
echo "----------- Entered Data ---------------------------------------------------------------"
echo $fName"; "$lName"; "$phone"; "$talkTime"; "$title"; "$venue"; " 
echo "----------------------------------------------------------------------------------------"


    echo -n "Do you want to save the updated data? (y/n): "
    read save_choice

    if [[ "$save_choice" == "y" || "$save_choice" == "Y" ]]; then
        echo "Speaker updated successfully."
	echo "$fName;$lName;$phone;$talkTime;$title;$venue" > edited_data.txt

    else
        echo "Changes discarded. Speaker not updated."
    fi


