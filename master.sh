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
#----------------------load_array-------------------------
#---------------------------------------------------------
load_array ()
{
zero=0
one=1
two=2
oIFS="$IFS"
IFS=$'\n'
for line in `cat $array`;
do
	IFS='|'
	arr=($line)
	users[$zero]=${arr[0]}
	users[$one]=${arr[1]}
	users[$two]=${arr[2]}
	((zero+=3))
	((one+=3))
	((two+=3))
done
IFS="$oIFS"
}

#---------------------------------------------------------
#------------------------log_in---------------------------
#---------------------------------------------------------
log_in ()
{
username=xx
while :
do
	printf "To log in, type your username or \"q\" to quit: "
	read user
	if [ $user = "q" ]; then
		exit
	fi
	i=0
	length=$(( ${#users[@]} + 1 ))  	#accounts for the array starting at zero
	length=$(( $length / 3 ))       	#stores the amount of users in the users.txt
	while [ $i -lt $length ]
	do
		x=$(( $i * 3 ))      		#the array index of the current user being checked
		if [[ "${user,,}" = "${users[$x],,}" ]]; then
			username="${users[$x]}"
			index_u=$x
			index_p=$(($x+1))
			index_r=$(($x+2))
			break
		else
			((i++))
		fi
	done
	if [ $username != "xx" ]; then
		while :
		do
			printf "Please enter your password or \"q\" to quit: "
			read pass
			if [[ $pass = "q" ]]; then
				exit
			fi
			if [[ $pass = "${users[index_p]}" ]]; then
				break
			else
				echo "Password incorrect."
			fi
		done
		break
	else
		echo "This user could not be found. Please try again."
		log_in
	fi
done
echo "You are now logged in!"
user="${users[index_u]}"
pass="${users[index_p]}"
role="${users[index_r]}"
main_menu
}

#---------------------------------------------------------
#------------------------log_out--------------------------
#---------------------------------------------------------
log_out () {
	user=xx
	pass=xx
	role=xx
	log_in
}

#---------------------------------------------------------
#--------------------change_password----------------------
#---------------------------------------------------------
change_password () {
while :
do
	printf 'Enter a new password: '
	read newpass
	if [ ${#newpass} -lt 3 ]
	then
		echo 'Please enter more than two characters.'
		continue
	fi
	echo "Thanks!"
	#FORMAT AND PUT INTO ARRAY/USERS.TXT
	#((index_p=$index_u+1))
	#((index_r=$index_u+2))
	newname="${users[$index_u]}"
	newrole="${users[$index_r]}"
	users[$index_u]="$newname" #replaces the old spot in the array with xx
	users[$index_p]="$newpass"
	users[$index_r]="$newrole"
	#update_file
	i=0
	length=$(( ${#users[@]} + 1 ))  	#accounts for the array starting at zero
	length=$(( $length / 3 ))       	#stores the amount of users in the users.txt
	> $array
	while [ $i -lt $length ]
	do
		x=$(($i*3))
		index_u=$x
		index_p=$(($x+1))
		index_r=$(($x+2))
		if [ "${users[$index_u]}" = "xx" ]; then
			((i++))
		else
			((i++))
			echo "${users[$index_u]}""|""${users[$index_p]}""|""${users[$index_r]}" >> $array
		fi
	done
	echo "Password changed!"
	load_array
	echo "DDDOOONNEE"
	main_menu
	break
done
}

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
	echo "7: Change password"
	echo "8: Exit"
	printf "What would you like to do? (Enter 1-8): "
	read choice
	case $choice in
		1)
			echo "------------------------------------------------"
			echo "Here is what's in the current working directory:"
			ls "$currentDir"
			echo "------------------------------------------------"
			;;
		2)
			while :
			do
				if [[ $currentDir = $DIR ]]; then
					echo "1: General"
					echo "2: Project"
					echo "3: Financial"
					printf "Which directory would you like to move to?"
					read where
					if [[ $where != 1 ]] && [[ $where != 2 ]] && [[ $where != 3 ]]; then
						echo '-----------------------'
						echo 'Please enter 1, 2, or 3'
						echo '-----------------------'
						continue
					fi
				fi
				echo "------------------------------------------------"
			done
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
			change_password
			;;
		8)
			exit
			;;
		*)
			echo "Please enter 1-7"
			;;
	esac
done
}

DIR="$(pwd)""/Folders"
currentDir="$DIR"
generalDir="DIR""/General"
projectDir="$DIR""/Project"
financialDir="$DIR""/Financial"
echo "Welcome!"
array=users.txt
load_array
log_in
