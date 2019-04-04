#!/bin/bash

# LIST OF FUNCTIONS:
# new_user
# mod_user
# rm_user
# reload_array

#---------------------------------------------------------------
#-----------------------reload_array----------------------------
#---------------------------------------------------------------
reload_array ()
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
#	echo "Username: ${arr[0]}"
#	echo "Password: ${arr[1]}"
#	echo "Role: ${arr[2]}"
	((zero+=3))
	((one+=3))
	((two+=3))
done
#printf '%s\n' "${users[@]}"
IFS="$oIFS"
}

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
	i=0
	length=$(( ${#users[@]} + 1 ))  	#accounts for the array starting at zero
	length=$(( $length / 3 ))       	#stores the amount of users in the users.txt
	while [ $i -lt $length ]
	do
		x=$(( $i * 3 ))      		#the array index of the current user being checked
		if [[ "${a,,}" = "${users[$x],,}" ]]; then
			#echo $x
			#echo "${users[$x]}"
			echo 'Username already taken. Please try again.'
			new_user
		elif [ ${#a} -lt 3 ]
		then
			echo 'Please enter more than two characters.'
			new_user
		else
			((i++))
		fi
	done
	break
done
echo 'Thank you!'
sleep 0.5

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
	if [ $c != 1 ] && [ $c != 2 ] && [ $c != 3 ]
	then
		echo '------------------------'
		echo 'Please enter 1, 2, or 3'
		echo '------------------------'
		continue
	fi
	echo 'Thank you!'
	sleep 0.5
	break
done

# Just for show
printf 'Adding user'
sleep 0.5
printf '.'
sleep 0.5
printf '.'
sleep 0.5
printf '. '
sleep 0.5

# Adding user to the end of users.txt
echo "$a""|""$b""|""$c" >> $array
echo "$a"" was added to the list of users!"
reload_array
main_menu
}

#-------------------------------------------------------------------
#-----------------------------mod_user------------------------------
#-------------------------------------------------------------------
mod_user ()
{
username=xx
while :
do
	printf 'Enter the username of the user you would like to modify or \"q\" to quit: '
	read a
	if [ $a = "q" ]; then
		main_menu
	fi
	i=0
	length=$(( ${#users[@]} + 1 ))  	#accounts for the array starting at zero
	length=$(( $length / 3 ))       	#stores the amount of users in the users.txt
	while [ $i -lt $length ]
	do
		x=$(( $i * 3 ))      		#the array index of the current user being checked
		if [[ "${a,,}" = "${users[$x],,}" ]]; then
			username="${users[$x]}"
			index=$x
			break
		else
			((i++))
		fi
	done
	if [ $username != "xx" ]; then
		break
	else
		echo "This user could not be found. Please try again."
		mod_user
	fi
done
echo 'Thank you!'
sleep 0.5
while :
do
	echo "1: username"
	echo "2: password"
	echo "3: role"
	printf "What would you like to modify about $username?"
	read change
	case $change in
		1)
			#change username
			while :
			do
				printf 'Enter a new username: '
				read newname
				i=0
				length=$(( ${#users[@]} + 1 ))  	#accounts for the array starting at zero
				length=$(( $length / 3 ))       	#stores the amount of users in the users.txt
				while [ $i -lt $length ]
				do
					x=$(( $i * 3 ))      		#the array index of the current user being checked
					if [[ "${newname,,}" = "${users[$x],,}" ]]; then
						echo 'Username already taken. Please try again.'
						continue
					elif [ ${#newname} -lt 3 ]
					then
						echo 'Please enter more than two characters.'
						continue
					else
						((i++))
					fi
				done
				((b=x+1))
				newpass="${users[$b]}"
				((c=x+2))
				newrole="${users[$c]}"
				echo "$newname""|""$newpass""|""$newrole"
				main_menu
				break
			done
			;;
		2)
			#change password
			;;
		3)
			#change role
			;;
		*)
			echo '------------------------------------------'
			echo '----------You did not enter 1-4-----------'
			echo '------------------------------------------'
			continue
			;;
	esac

done
exit
reload_array
}

#-------------------------------------------------------------------
#-----------------------------rm_user-------------------------------
#-------------------------------------------------------------------
#rm_user()
#{
#while :
#do
#	printf 'Which user would you like to remove? '
#	read remove
#	if grep -iwq '$remove' $array
#	then
#		#REMOVE USER
#	else
#		echo 'This user does not exist'
#		continue
#	fi
#done
#reload_array
#}


#-------------------------------------------------------------------
#---------------------------main_menu----------------------------
#-------------------------------------------------------------------
main_menu ()
{
while :
do
	echo '1: add a new user'
	echo '2: modify and existing user'
	echo '3: remove a user'
	echo '4: exit'
	printf 'Enter a number 1-4: '
	read choice
	case $choice in
		1)
			new_user
			;;
		2)
			mod_user
			;;
		3)
			#rm_user
			;;
		4)
			exit
			;;
		*)
			echo '------------------------------------------'
			echo '----------You did not enter 1-4-----------'
			echo '------------------------------------------'
			continue
			;;
	esac
	main_menu
done
}

# Starting the script
array=users.txt
reload_array
main_menu
