# !/bin/bash
# Sciprt Name: removeRecord.sh
# Author: Kate Molony
# Programme : This is used to remove records on the text file


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
# Define colors
PINK='\033[0;35m'
NC='\033[0m' # No Color

# Display the title and description in orange
echo "======================================"
echo -e "${PINK}         Remove Record${NC}"
echo "======================================"
echo "Welcome to the Tech Conference Catalogue."
echo "Here, you can add a new record to the catalogue."
echo ""
echo "Type q and press enter to return to the main menu"
echo""

PS3=$'\033[0;35m1)List All 2)Duplicates 3)Quit \e[0m: '
options=("List all talks" "Search for duplicates" "Quit and exit the command")
select opt in "${options[@]}"
do
    case $opt in

        #List all talks
        "List all talks")

awk -F' ; ' 'BEGIN {printf "--------------------------------------------------------------------------------\n"}
             BEGIN {printf "| %-4s | %-7s | %-25s | %-18s | %-10s |\n", "No.", "Time", "Title", "Speaker", "Venue"}
             BEGIN {printf "--------------------------------------------------------------------------------\n"}
             {gsub(/;$/, "", $7); printf "| %-4s | %-7s | %-25s | %-18s | %-10s |\n", $1, $5, $6, $2 " " $3, $7}
             END {printf "--------------------------------------------------------------------------------\n"}' "$file_path"

		./removeLine.sh

	read -p "Would you like to remove another line (y/n): " answer

	if [[ "$answer"  ==  "y" || "$answer" == "Y" ]]
	then

	./removeLine.sh

	else

	break

	fi
	;;

        "Search for duplicates")

# This searches for clashes with the same venue and time 
# Array to store time and venue combinations
	declare -A time_venue_combinations

awk -F' ; ' '{
    time = $5
    venue = $7
    key = time " ; " venue

    if (key in time_venue_combinations) {
        if (time_venue_combinations[key] == $0) {
            # Duplicate combination found on the same line
            print "-----------------------------------------------------"
            print "Duplicate Time and Venue:", key
            print ""
            print "Line with the duplicate time and venue:"
            print time_venue_combinations[key]
            print "-----------------------------------------------------"
            found_duplicates = 1
        } else {
            # Duplicate combination found on different lines
            print "-----------------------------------------------------"
            print "Duplicate Time and Venue:", key
            print ""
            print "Line with the duplicate time and venue:"
            print time_venue_combinations[key]
            print $0
            print "-----------------------------------------------------"
            found_duplicates = 1
        }
    } else {
        time_venue_combinations[key] = $0
    }
}
END {
    if (found_duplicates != 1) {
	print "No duplicates found"
        exit
    } else {
        # Call another shell script when duplicates are found
        system("bash editDuplicates.sh")
    }
}' "$file_path"

;;

        "Quit and exit the command")
	break
	;;


        *) echo -e "\n invalid option $REPLY";;
    esac
done
