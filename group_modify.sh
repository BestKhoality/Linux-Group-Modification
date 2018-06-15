#!/bin/bash

function group_modify
{
#!/bin/bash
printf "\n"
echo "-----------------------------------------------"
printf "User Group Management Utility v1.0\n" 
echo "-----------------------------------------------"
printf "\n"

input="1"

while [ $input -ne "0" ]
do
	printf "Press 1: Groupadd\n"
	printf "Press 2: Groupdel\n"
	printf "Press 3: Useradd\n"
	printf "Press 4: Usermod\n"
	printf "Press 5: Userdel\n"
	printf "Press 0: Exit Utility\n"
	printf "Please select an option: "

	read input

	if [ $input == 1 ]
	then
		printf "Please enter a groupname to be added: "
		read groupname
		value=$( grep -ic "$groupname" /etc/group )
		
		if [ $value == 1 ]
		then
			printf "$groupname already exists!\n"
			group_modify
		else
			groupadd $groupname
			value=$( grep -ic "$groupname" /etc/group )
			
				if [ $value == 1 ]
				then
					printf "$groupname was successfully added!\n"
					exit
				else
					printf "$groupname was not successfully added!\n"
					exit
				fi
		fi
	elif [ $input == 2 ]
	then
		printf "Please enter a groupname to be deleted: "
		read groupname
		if grep -q "$groupname" /etc/group
                then
                        groupdel $groupname
			printf "$groupname was successfully deleted!\n"
                        exit
                else	
                        printf "$groupname does not currently exist!\n"
                        group_modify
                fi

	elif [ $input == 3 ]
	then
		
		printf "Enter a user name to be added: "
		read username
		value=$( grep -ic "$username" /etc/passwd )
		if [ $value == 1 ]
		then
			printf "User $username already exists!\n"
			exit
		else
			useradd $username
			printf "User $username added successfully!\n"
			exit
		fi	

	elif [ $input == 4 ]
	then
		
		printf "Enter existing username to assign to different user group: "
		read username
		if grep -q "$username" /etc/passwd
		then
			printf "Username validated successfully!\n"
			printf "Enter existing group name to be added to: "
			read groupname
			if grep -q "$groupname" /etc/group
			then
				usermod -a -G $groupname $username
				cat /etc/group | grep $groupname
				printf "User modification completed successfully!\n"
				exit
			else
				printf "Username validated failed, does user exist?\n"
				group_modify
			fi
		fi
	elif [ $input == 5 ]
	then
		
		printf "Enter an existing username to be deleted: "
		read username
		if grep -q "$username" /etc/passwd
		then
			printf "Username validated successfully!\n"
			userdel $username
			value2=$( grep -ic $username /etc/passwd )
			if [ $value2 == 0 ]
			then
				printf "User delete completed successfully!\n"
				exit
			else
				printf "User delete failed!\n"
				group_modify
			fi
		fi
	elif [ $input == 0 ]
	then
		printf "Exiting utility...\n"
		exit
	else
		printf "Input received is invalid!\n"
		printf "Program Exiting!\n"
		group_modify
		printf "\n"
		printf "\n"
	fi
done
}
