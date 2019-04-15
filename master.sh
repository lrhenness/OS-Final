#!/bin/bash
# This is the master script for the Group 2 Final project

#---------------------------
# list of functions:
# load_array
# log_in
# log_out
# change_password
# main_menu
#---------------------------
# functions of main_menu:
# 	list working directory
# 	move directories
# 	create (touch) file
# 	open (nano) file
# 	delete (rm) file
# 	show errors (grep)
#	change password
#	log out
#	exit script
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
		if [[ ${users[index_p]} = "password123" ]]; then
			while :
			do
				printf "First time login. Please enter a new password or \"q\" to quit: "
				read pass
				if [[ $pass = "q" ]]; then
					exit
				fi
				if [ ${#pass} -lt 3 ]
				then
					echo 'Please enter more than two characters.'
					continue
				fi
				break
			done
			break
		else
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
		fi
	else
		echo "This user could not be found. Please try again."
		log_in
	fi
done
echo '----------------------'
echo "You are now logged in!"
echo '----------------------'
user="${users[index_u]}"
pass="${users[index_p]}"
role="${users[index_r]}"
main_menu
}

#---------------------------------------------------------
#------------------------log_out--------------------------
#---------------------------------------------------------
log_out () {
echo '--------------------'
echo "You have logged out!"
echo '--------------------'
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
	echo "1: List current working directory"
	echo "2: Move directories"
	echo "3: Create file"
	echo "4: Open file"
	echo "5: Delete file"
	echo "6: Show file errors"
	echo "7: Change password"
	echo "8: Log out"
	echo "9: Exit"
	printf "What would you like to do? (Enter 1-9): "
	read choice
	case $choice in
		1) #List wd
			echo "------------------------------------------------"
			echo "Here is what's in the current working directory:"
			if [ $currentDir = $DIR ]; then
				echo "General/     Project/     Financial/"
			else
				ls $currentDir
			fi
			echo "------------------------------------------------"
			;;
		2) #Move directories
			while :
			do
				echo "1: General"
				echo "2: Project"
				echo "3: Financial"
				printf "Which directory would you like to move to? (1-3) "
				read where
				case $where in
					1)
						currentDir=$generalDir
						echo "------------------------------------------------"
						echo "You are now in the General directory"
						ls $currentDir
						echo "------------------------------------------------"
						main_menu
						;;
					2)
						if [ $role != 2 ] && [ $role != 3 ]; then
							echo "You are not allowed access to this directory."
							main_menu
						fi
						currentDir=$projectDir
						echo "------------------------------------------------"
						echo "You are now in the Project directory"
						ls $currentDir
						echo "------------------------------------------------"
						main_menu
						;;
					3)
						if [ $role != 3 ]; then
							echo "You are not allowed access to this directory."
							main_menu
						fi
						currentDir=$financialDir
						echo "------------------------------------------------"
						echo "You are now in the Financial directory"
						ls $currentDir
						echo "------------------------------------------------"
						main_menu
						;;
					*)
						echo '-----------------------'
						echo 'Please enter 1, 2, or 3'
						echo '-----------------------'
						;;
				esac
			done
			;;
		3) #Create file
			if [ $currentDir = $DIR ]; then
				echo '---------------------------------'
				echo "Please move to a directory first."
				echo '---------------------------------'
				main_menu
			fi
			while :
			do
				printf "Enter a name for the file or \"q\" to quit: "
				read fileName
				if [ $fileName = "q" ]; then
					exit
				elif [ ${#fileName} -lt 3 ]; then
					echo "Please enter more than 2 characters"
					continue
				else
					break
				fi
			done
			> "$currentDir""/""$fileName"
			echo '---------------------------------------'
			echo "The file ""$fileName"" has been created"
			echo '---------------------------------------'
			;;
		4) #Open file
			if [ $currentDir = $DIR ]; then
				echo '---------------------------------'
				echo "Please move to a directory first."
				echo '---------------------------------'
				main_menu
			fi
			while :
			do
				echo "Enter the name of an existing file"
				printf "or a new file you want to open or \"q\" to quit: "
				read file
				if [ $file = "q" ]; then
					exit
				fi
				nano "$currentDir""/""$file"
				echo '--------------------------------------'
				echo "Your file, ""$file"" was created."
				echo '--------------------------------------'
			done
			;;
		5) #Delete file
			#Comment this next if statement out if any user can delete files in the current dir
			if [ $role != "3" ]; then
				echo '-------------------------------------------'
				echo "You do not have permission to delete files."
				echo '-------------------------------------------'
				main_menu
			fi
			while :
			do
				ls $currentDir
				printf "Enter the name of a file you would like to delete or \"q\" to quit: "
				read remove
				if [ $remove = "q" ]; then
					exit
				fi
				rm "$currentDir""/""$remove"
			done
			;;
		6) #Show errors in files
			echo '--------------------------------------------------------------------------------------'
			case $currentDir in
				$DIR)
					echo "Please move to a directory first"
					;;
				$generalDir)
					grep -rn "ERROR:" Folders/General/
					;;
				$projectDir)
					grep -rn "ERROR:" Folders/Project/
					;;
				$financialDir)
					grep -rn "ERROR:" Folders/Finanacial/
					;;
			esac
			echo '--------------------------------------------------------------------------------------'
			;;
		7) #Change password
			change_password
			;;
		8) #Log out
			log_out
			;;
		9) #Exit
			exit
			;;
		*)
			echo "Please enter 1-9"
			;;
	esac
done
}

DIR="$(pwd)""/Folders"
currentDir="$DIR"
generalDir="$DIR""/General"
projectDir="$DIR""/Project"
financialDir="$DIR""/Financial"
echo "Welcome!"
array=users.txt
load_array
log_in
