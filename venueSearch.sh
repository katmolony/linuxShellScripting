# !/bin/bash
# Sciprt Name: venueSearch.sh
# Author: Kate Molony
# Programme: This searches the venues, using the 
# variables sent in from regSearch.sh

#check if file exists, if not make copy of file
if [ -a ~/contactdetails.txt ]; 

then
        file_path="contactdetails.txt"

else
        cp contactdetails.txt contactdetails.bak
        file_path="contactdetails.bak"

fi


venue="$1"

# Use the variable
echo "Received variable: $venue"
echo ""

# Check if there are any talks held in the venue 
if grep -q -i ".*;.*;.*;.*;.*; $venue " "$file_path"; then
    # Filter lines for the venue "$venue"
    filtered_lines=$(grep -i ".*;.*;.*;.*;.*; $venue " "$file_path")

    # Use awk to format and sort the data
    sorted_output=$(echo "$filtered_lines" | awk -F';' '{print $5 ";" $6 ";" $2" "$3}' | sort)

    # Format and print the sorted output
    echo -e "--------------------------------------------------------------------"
    echo -e "| Time        | Title                   | Speaker                  |"
    echo -e "--------------------------------------------------------------------"

    echo "$sorted_output" | awk -F';' '{printf "| %-11s | %-23s | %-23s |\n", $1, $2, $3}'

    echo -e "--------------------------------------------------------------------"
        lines_count=$(echo "$filtered_lines" | wc -l)
        echo "The search returned $lines_count talks"

else
    echo "No talks are being held in this venue yet."
fi

