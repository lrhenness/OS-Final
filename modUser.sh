#!/bin/bash

# LIST OF FUNCTIONS:
# new_user
# mod_user
# rm_user

array=users.txt
readarray -t users < $array

printf "."
sleep 0.5

echo "."

#---------------------------------------------------------------
#-------------------------new_user------------------------------
#---------------------------------------------------------------
new_user ()
{
# Entering a username and checking for availability
while :
do
	printf 'Enter a username: '
	read a
	if grep -iwo "$a" $array
	then
		echo '------------------------------------------'
		echo 'Username already taken. Please try again.'
		echo '------------------------------------------'
		continue
	fi
	echo 'Thank you!'
	sleep 0.5
	echo '-----------'
	break
done

# Default password
b=password123

# Entering a password and checking conditions
while :
do
	echo '1: Intern user'
	echo '2: General user'
	echo '3: Power user'
	printf 'Enter a level (1-3): '
	read c
	if [ $c -lt 1 ] || [ $c -gt 3 ]
	then
		echo '------------------------'
		echo 'Please enter 1, 2, or 3'
		echo '------------------------'
		continue
	fi
	echo 'Thank you!'
	sleep 0.5
	echo '-----------'
	break
done

# Just for show
#echo 'Adding user.'
#sleep 0.5
#echo 'Adding user..'
#sleep 0.5
#echo 'Adding user...'

# Adding user to the end of users.txt
echo "$a $b $c" >> $array
echo "$a was added to the list of users!"
}

#-------------------------------------------------------------------
#-----------------------------mod_user------------------------------
#-------------------------------------------------------------------
mod_user ()
{
while :
do
	printf 'Enter the user you want to modify: '
	read x
	if grep -iwo "$x" $array
	then
		echo "1: username"
		echo "2: password"
		echo "3: access level"
		printf "Which would you like to modify about $x? "
		read y
	else
		echo '------------------------------------------'
		echo '    User not found. Please try again.'
		echo '------------------------------------------'
		continue
	fi
	echo 'Thank you!'
	sleep 0.5
	echo '-----------'
	break
done
}


#-------------------------------------------------------------------
#---------------------------landing_page----------------------------
#-------------------------------------------------------------------
landing_page ()
{
while :
do
	echo "1: add a new user"
	echo "2: modify and existing user"
	echo "3: remove a user"
	echo "4: exit"
	printf "Enter a number 1-4: "
	read choice
	case $choice in
		1)
			new_user
			;;
		2)
			#modUser
			;;
		3)
			#rmUser
			;;
		4)
			exit
			;;
		*)
			echo '------------------------------------------'
			echo 	     "You did not enter 1-4"
			echo '------------------------------------------'
			continue
			;;
	esac
	landing_page
done
}

# Starting the script
landing_page