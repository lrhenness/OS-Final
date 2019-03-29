#!/bin/bash

# Reading users.txt file into array
readarray -t users < users.txt
#for i in "${users[@]}"
#do
#echo $i
#done

# Entering a username and checking for availability
while :
do
	echo 'Enter a username: '
	read a
	if grep -iwo "$a" users.txt
	then
		echo '------------------------------------------'
		echo 'Username already taken. Please try again.'
		echo '------------------------------------------'
		continue
	fi
	echo 'Thank you!'
	sleep 1
	echo '-----------'
	break
done

# Default password
b=password123

# Entering a password and checking conditions
while :
do
	echo 'Level options include:'
	echo '1: Intern user'
	echo '2: General user'
	echo '3: Power user'
	echo 'Enter a level (1-3): '
	read c
	if [ $c -lt 1 ] || [ $c -gt 3 ]
	then
		echo '------------------------'
		echo 'Please enter 1, 2, or 3'
		echo '------------------------'
		continue
	fi
	echo 'Thank you!'
	sleep 1
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
echo "$a $b $c" >> users.txt
