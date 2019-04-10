#!/bin/bash
# This is the master script for the Group 2 Final project

#---------------------------
# list of functions:
# log_in
# log_out
# change_password
# main_menu
#---------------------------
# functions of main_menu:
# 	move directories
# 	list directories
# 	create (touch) file
# 	open (nano) file
# 	delete (rm) file
# 	show errors (grep)
#---------------------------


#---------------------------------------------------------
#------------------------log_in---------------------------
#---------------------------------------------------------
#log_in () {

#}

#---------------------------------------------------------
#------------------------log_out--------------------------
#---------------------------------------------------------
#log_out () {

#}

#---------------------------------------------------------
#--------------------change_password----------------------
#---------------------------------------------------------
#change_password () {

#}

#---------------------------------------------------------
#-----------------------main_menu-------------------------
#---------------------------------------------------------
main_menu () {
while :
do
	echo "1: List directories"
	echo "2: Move directories"
	echo "3: Create file"
	echo "4: Open file"
	echo "5: Delete file"
	echo "6: Show file errors"
	echo "7: Exit"
	printf "What would you like to do? (Enter 1-7): "
	read choice
	case $choice in
		1)
			
			;;
		2)
			;;
		3)
			;;
		4)
			;;
		5)
			;;
		6)
			;;
		7)
			;;
		*)
			echo "Please enter 1-7"
			;;
	esac
done
}

echo "Welcome!"
main_menu
