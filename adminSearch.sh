# !/bin/bash
# Sciprt Name: adminSearch.sh
# Author: Kate Molony
# Programme : This programme is password protected
# allowing only a site admin to search for contact details of speakers

#check if file exists, if not make copy of file
if [ -a ~/contactdetails.txt ]; then
#file path must be established as a variable
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
        echo -e "| Title                      | Speaker                | Contact                |"
        echo -e "--------------------------------------------------------------------------------"

        echo "$filtered_lines" | while IFS=';' read -ra variables; do
            printf "| %-26s | %-22s | %-22s |\n" "${variables[5]}" "${variables[1]} ${variables[2]}" "${variables[3]}"
        done

        echo -e "--------------------------------------------------------------------------------"
        lines_count=$(echo "$filtered_lines" | wc -l)
        echo "The search returned $lines_count talks"

    else
        echo "No matches found."
    fi
}

password="password"
echo ""
echo "Please enter the password to proceed"
echo "Wrong password will exit"
echo ""
read -s entered_password  # -s flag hides the input

# Check if the entered password is correct
if [ "$entered_password" == "$password" ]; then
    echo "Password accepted."
    echo "Welcome to admin search"
    echo "To find a speakers contact"
    echo ""

#within a while loop to repeat search if not found
while :; do 
echo "Please enter a Speaker's name "
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

  # Check if either fname or lname contains at least one string character
    if [[ -n "$fName" || -n "$lName" ]]; then

	# Check if the talk exists in the file
	if grep -q -i ".*;.*$fName.*$lName.*;.*;.*;.*" "$file_path"; then
	# Filter lines for the specified talk
	filtered_lines=$(grep -i ".*;.*$fName.*$lName.*;.*;.*;.*" "$file_path")

	display_search_results "$filtered_lines"

	break

	else

	echo ""
	echo "Speaker not found in the file."
	echo -e "or invalid name was typed"
	echo -e "Please try again"
	echo ""

	fi

	else
	echo ""
        echo "Please provide at least one character for either first name or last name."
	echo ""
	fi

done

else
    echo ""
    echo "Incorrect password. Access denied."
    echo ""
fi
