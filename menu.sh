# !/bin/bash
# Sciprt Name: menu.sh
# Author: Kate Molony
# Programme: This is the beginning menu for the conference cataloge
# which gives the user the option to add, search or remove records
# in the confrence cataloge


GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "==========================================="
echo -e "${GREEN}     Tech Conference Catalogue Menu${NC}"
echo "==========================================="
echo ""
echo "Welcome to the Tech Conference Catalogue."
echo "Here, you can add speakers and talks,"
echo "search for records, and remove entries" 
echo "from the catalogue."
echo ""
echo "This is the main menu, type the number that"
echo "corresponds to the action and press enter"
echo ""

PS3=$'\033[0;32m1) Add 2) Search 3) Delete 4) Exit \e[0m: '
options=("Add a new record" "Search within the catalogue" "Delete a record" "Exit and Quit")
select opt in "${options[@]}"

do
    case $opt in
        "Add a new record")
            ./addRecord.sh
            ;;
        "Search within the catalogue")
            ./searchRecord.sh
            ;;
        "Delete a record")
            ./removeRecord.sh
            ;;
        "Exit and Quit")
            echo "You chose to exit. Bye!"
	    exit
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
