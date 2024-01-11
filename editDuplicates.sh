# !/bin/bash
# Sciprt Name: editDuplicates.sh
# Author: Kate Molony
# Programme : This is used to edit the choosen duplicates


#check if file exists, if not make copy of file
if [ -a ~/contactdetails.txt ]; 

then
#file path must be established as a variable
        file_path="contactdetails.txt"

else

        cp contactdetails.txt contactdetails.bak
        file_path="contactdetails.bak"

fi
echo ""
 
# Gives users the option to edit the time
# and venue of clashing talks
read -p "Would you like to edit the duplicate lines (y/n): " answer

if [[ "$answer"  ==  "y" || "$answer" == "Y" ]]
then

echo ""
read -p "Enter the line number of the line you want to edit (or 0 to exit): " line_number

if [ $line_number -eq 0 ]; then
    echo ""
    echo "No changes made. Exiting."
    echo ""
else

echo ""
echo "Press q and enter to quit"
echo ""


while true; do
    echo ""
    echo -n "Enter the new time (HH:MM): "
    read new_time


    if [[ "$new_time" == [qQ] ]]; then
        echo ""
        echo "Returning to remove record."
        exit 0
    fi
        # Define a pattern to validate the input
        pattern="^([01]?[0-9]|2[0-3]):[0-5][0-9]$"

        # Check if the user input matches the pattern
        if [[ $new_time =~ $pattern ]]; then

                break
        else
        echo "Invalid input. Please enter a time in 24-hour format (HH:MM)."
     fi

done

        while true; do
          read -p "Enter new Venue: " new_venue 

           new_venue=${new_venue^^}  # Convert to uppercase

              if [[ "$new_venue" == [qQ] ]]; then
                echo ""
                echo "Cancelling editing."
                exit
              fi

              # input must match The 5 options
              if [[ ! -z "${new_venue}" && ( "${new_venue}" == "GY101" || "${new_venue}" == "GY102" || "${new_venue}" == "GY103" || "${new_venue}" == "GY104" || "${new_venue}" == "GY105" ) ]]

                then

                break 

              else

                echo "Warning: Please enter a valid venue (GY101, GY102, GY103, GY104, GY105)"

                fi
              done


# Modify the selected line with the new time and venue, using ";" as the delimi>
awk -v line_number="$line_number" -v new_time="$new_time" -v new_venue="$new_venue" 'BEGIN { FS=" ; "; OFS=" ; " } {
    if (NR == line_number) {
        $5 = new_time
        $7 = new_venue
    }
    print
}' "$file_path" > tmpfile && mv tmpfile "$file_path"

        echo "Line $line_number updated with new time and venue."
        fi
fi



