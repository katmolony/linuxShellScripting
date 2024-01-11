# !/bin/bash
# Sciprt Name: removeLine.sh
# Author: Kate Molony
# Programme : This is used to remove a line in the text file
# allows the user to continue deleting lines

#check if file exists, if not make copy of file
if [ -a ~/contactdetails.txt ]; 

then
#file path must be established as a variable
        file_path="contactdetails.txt"

else

        cp contactdetails.txt contactdetails.bak
        file_path="contactdetails.bak"

fi

while true; do

echo "---------------------------------------------"
read -p "Enter the line number to remove: " line_number_to_remove
echo "---------------------------------------------"
echo ""

    if [[ $line_number_to_remove =~ ^[0-9]+$ ]]; then
        # The input is a valid number
        break
    else
        echo "Error: Please enter a valid number."
    fi
done

result=$(grep -n "^$line_number_to_remove ;" "$file_path")

echo "--------------------------------------------------------------------------------"
echo "$result" | while IFS=';' read -ra variables; do
            printf "| %-9s | %-10s | %-26s | %-22s |\n" "${variables[4]}" "${variables[6]}" "${variables[5]}" "${variables[1]} ${variables[2]}"
        done

echo "--------------------------------------------------------------------------------"

echo ""
read -p "Are you sure you want to remove this item? (y/n or q to quit): " confirmation
echo""

# Check the user's input
if [[ "$confirmation" == "y" ]]; then

        # Use sed to remove the line with the specified line number
        sed -i "${line_number_to_remove}d" "$file_path"
        echo "Line number $line_number_to_remove removed from $file_path"
        echo ""

        # Give the entries new line numbers
        # Temporary file for storing modified data
        temp_file="temp_contactdetails.txt"

        # Counter for the line numbers
        line_number=1

        while IFS= read -r line; do
        # Skip empty lines
        if [ -z "$line" ]; then
                continue
        fi

        # Add the new line number as a prefix to each line
        modified_line="$line_number ;${line#*;}"
        echo "$modified_line"
        ((line_number++))
        done < "$file_path" > "$temp_file"

        # Replace the original file with the modified file
        mv "$temp_file" "$file_path"

elif [[ "$confirmation" == "n" ]]; then

    echo ""
    echo "No action taken."
    echo""

elif [[ "$confirmation" == "q" ]]; then

    echo ""
    echo "Quitting. Item not removed."
    echo ""

else
    echo ""
    echo "Invalid input. Please enter 'y' 'n' or 'q' to quit."
    echo ""
fi
