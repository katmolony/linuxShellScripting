# !/bin/bash
# Author: Kate Molony

# This programme searches and displays
# wages of employee's from the employee text file
# using menu options for user friendly use

#check if file exists, if not make copy of file
if [ -a ~/contactdetails.txt ]; 

then
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


# Define colors
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Display the title and description
echo "======================================"
echo -e "${YELLOW}       Search Record${NC}"
echo "======================================"
echo "Welcome to the Tech Conference Catalogue."
echo "Here, you can search for a record in the catalogue."
echo ""

PS3=$'\033[0;33m1)List All 2)Search 3)Adv. Search 4)Quit\e[0m: '
options=("List all talks" "Search for a talk" "Advanced Search (Admin only)" "Quit and exit")
select opt in "${options[@]}"
do
    case $opt in

        #List all talks
        "List all talks")

# Display the sorting options to the user
echo ""
echo "Choose a variable to sort by:"
echo "1) Sort by Venue"
echo "2) Sort by Time"
echo "3) Return to main menu"
read -rsn1 sort_option #read is invisible and w/o enter
echo ""

# Sort the file based on user input
case $sort_option in
    1)
	# Sort by Venue, then Time within the Venue
	# Filter lines for the specified talk
	filtered_lines=$(sort -t';' -k7,7 -k5,5 "$file_path")

        display_search_results "$filtered_lines"
        ;;

    2)
	# Sort by Time
        filtered_lines=$(sort -t';' -k5 "$file_path")

        display_search_results "$filtered_lines"
        ;;

    3) break;;

    *)
        echo "Invalid option. Default sorting by Time within Venue."
        filtered_lines=$(sort -t';' -k7,7 -k5,5 "$file_path")

        display_search_results "$filtered_lines"
	esac
	;;

     #Searchs file for specific variable
        "Search for a talk")
	./regSearch.sh
	;;

	"Advanced Search (Admin only)")
	./adminSearch.sh
	;;

        "Quit and exit")
	break
	;;

        *) echo -e "\n invalid option $REPLY";;
    esac
done
