# !/bin/bash
# Sciprt Name: regSearch.sh
# Author: Kate Molony
# Programme: This programme searches and displays record from
# the text file

#check if file exists, if not make copy of file
if [ -a ~/contactdetails.txt ]; 

then
        file_path="contactdetails.txt"

else
        cp contactdetails.txt contactdetails.bak
        file_path="contactdetails.bak"

fi

# This function displays search results in a table format
display_search_results() {
    local filtered_lines="$1"

    if [ -n "$filtered_lines" ]; then
        echo -e "--------------------------------------------------------------------------------"
        echo -e "| Time      | Venue      | Title                      | Speaker                |"
        echo -e "--------------------------------------------------------------------------------"

        echo "$filtered_lines" | while IFS=';' read -ra variables; do
            printf "| %-9s | %-10s | %-26s | %-22s |\n" "${variables[4]}" "${variables[6]}" "${variables[5]}" "${variables[1]} ${variables[2]}"
        done

        echo -e "--------------------------------------------------------------------------------"
        lines_count=$(echo "$filtered_lines" | wc -l)
        echo "The search returned $lines_count talks"

    else
        echo "No matches found."
    fi
}

echo ""
echo "What would you like to search by"
echo ""
PS3='1)Speaker 2)Talk 3)Time 4)Venue 5)Quit '
options=("Speaker" "Talk" "Time" "Venue" "Quit")
select opt in "${options[@]}"
do
    case $opt in

"Speaker")
echo""
echo "Please enter a Speaker's name "
echo "Type q and enter to exit"
echo ""
read -p "Enter first name: " fName

if [[ "$fName" == [qQ] ]]; then
    echo ""
    echo "Returning to search."
    echo ""
    exit 0
fi

read -p "Enter last name: " lName

if [[ "$lName" == [qQ] ]]; then
    echo ""
    echo "Returning to search."
    echo ""
    exit 0
fi

# Check if the talk exists in the file
if grep -q -i ".*;.*$fName.*$lName.*;.*;.*;.*" "$file_path"; then
    # Filter lines for the specified talk
    filtered_lines=$(grep -i ".*;.*$fName.*$lName.*;.*;.*;.*" "$file_path")

 display_search_results "$filtered_lines"

else
    echo "Speaker not found in the file."
fi
;;

"Talk")

echo ""
echo "Please enter a title of speech"
echo "Type q and enter to exit"
echo ""
read -p "Enter talk title: " talk

if [[ "$talk" == [qQ] ]]; then
    echo ""
    echo "Returning to search."
    echo ""
    exit 0
fi


# Check if the talk exists in the file
if grep -q -i ".*;.*;.*;.*;.*;.* $talk.*" "$file_path"; then
    # Filter lines for the specified talk
    filtered_lines=$(grep -i ".*;.*;.*;.*;.*;.* $talk.*" "$file_path")

	display_search_results "$filtered_lines"
else
    echo "Talk not found in the file."
fi
;;

"Time")

echo ""
echo "Please enter a time"
echo "Type q and enter to exit"
echo ""

while true; do
    read -p "Please enter a time in 24-hour format (HH:MM) or type 'q' to quit: "talkTime

    if [ "$talkTime" == "q" ]; then
    echo ""
    echo "Returning to search."
    echo ""
    exit 0

    fi

    # Pattern to validate the input
    pattern="^([01]?[0-9]|2[0-3]):[0-5][0-9]$"

    # Check if the user input matches the pattern
    if [[ $talkTime =~ $pattern ]]; then
        echo "You entered a valid 24-hour time: $talkTime"

        # Filter lines for the specified talk
        filtered_lines=$(grep -i ".*;.*;.*;.*; $talkTime ;.*" "$file_path")

        # Display search results or perform other operations here
        display_search_results "$filtered_lines"

        break  # Exit the loop as valid input has been provided
    else
        echo "Invalid input. Please enter a time in 24-hour format (HH:MM)."
    fi

done

;;

"Venue")

# Display a menu with five options
echo ""
echo "Select a venue"
echo "1. GY101  2. GY102  3. GY103  4. GY104  5. GY105"
echo "0. Exit"

# Read the user's choice
read -p "Enter the venue: " venue

# Use a case statement to perform actions based on the user's choice
case $venue in
    1) ./venueSearch.sh "GY101" ;;
    2) ./venueSearch.sh "GY102" ;;
    3) ./venueSearch.sh "GY103" ;;
    4) ./venueSearch.sh "GY104" ;;
    5) ./venueSearch.sh "GY105" ;;
    0) echo ""
        exit 0;;
    *) echo "Invalid choice. Please select a valid option (1-5) or 0 to exit."
        ;;
esac
;;

"Quit")
break 
;;

esac 
done
