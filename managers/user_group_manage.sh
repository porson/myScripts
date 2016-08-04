#!/bin/bash
#@lpx_2016-1-19

#########################################################################################
welcom(){
	echo
	echo -e "\t\t\t\e[40;36mWelcome to the User_Group_Manager shell script.\e[0m"
	echo -e "\t\t   \e[40;36m Please input the number to choice what you want to do.\e[0m"
	echo -e "\e[34m"
	echo -e "\t\t\t\t1.Create a new user."
	echo -e "\t\t\t\t2.Reset user's password."
	echo -e "\t\t\t\t3.Modify user information."
	echo -e "\t\t\t\t4.Delete a user account and related files."
	echo -e "\t\t\t\t5.Check the user information.\e[0m"
	echo -e "\e[36m"
	echo -e "\t\t\t\t6.Add a new group in linux."
	echo -e "\t\t\t\t7.Delete a existed group from linux."
	echo -e "\t\t\t\t8.Chek the mumbers in the group."
	echo
	echo -e "\t\t\t\t\e[35m0.Exit\e[0m\n"
}
#########################################################################################
#1
addUser(){
	clear
	show
	echo 
	read -p "        Please input your user name:" user_name
	if id $user_name &>/dev/unll 
	then
		echo -e "\n\t\t\t   \e[31mUser \" $user_name\" already exists.\e[0m\n"	
	else
		echo 
		read -s -p "        Please input your password:" passwd
		echo
		useradd $user_name 1>/dev/null
		echo $passwd |passwd $user_name --stdin 1>/dev/null
		echo 
		id $user_name &>/dev/null && echo -e "\t\t\t    User $user_name creat \e[31mSuccessed\e[0m." || echo -e "\t\t\t    User $user_name creat \e[31mFailed\e0m"
	fi
}
########################################################################################
#2
resetPasswd(){
	clear
	show
	echo
	read -p "        Please input the account: " account
	echo
	if id $account &>/dev/null
	then
		while true
		do
			read -s -p "        Please input the new password: " passwd
			echo -e "\n"
			read -s -p "            Plesae reput the password: " repass
			echo -e "\n"
			if [ "$passwd" -eq "$repass" ]
			then
				echo $passwd |passwd --stdin $account &>/dev/null  && \
				echo -e "\t\t\t    Passwd reset \e[31mSuccessed\e[0m."
				return
			else
				echo -e "\t\t\t\t\e[31mPasswords do not match.\e[0m\n"
				echo
				read -p "                Please input any key to continue"
				clear	
			fi
		done
	else
		echo -e "\n\t\t\t   \e[31mUser \" $user_name\" do not exists.\e[0m\n"	
	fi
}
########################################################################################
# 3
modify(){
	clear
	show
	gshow
	echo
	read -p  "        Please input user_name which you want to modify: " user_name
	echo
        if id $account &>/dev/null
        then
		clear
        	echo -e "\t\t   \e[42;36m Please input the number to choice what you want to modify.\e[0m"
		while true
		do
			clear
			echo -e "\n\t\t\t\e[33m1.Change user's uid.\e[0m"
			echo -e "\n\t\t\t\e[33m2.Change user's gid.\e[0m"
			echo -e "\n\t\t\t\e[33m3.Change user's hume directory.\e[0m"
			echo -e "\n\t\t\t\e[33m4.Lock this account.\e[0m"
			echo -e "\n\n\t\t\t\e[36m0.Exit.\e[0m"
			echo
			read -p "        Which option do you want ? :" choice
			echo
			case $choice in
			0)
				return;;
			1)
				read -p "        Please input new uid: " uid
				echo
				cat /etc/passwd |awk -F: '{print $3}'| grep "^$uid$" &>/etc/null && read -p "        The uid existed, still modify ?(y/n): " answer ||usermod -u $uid $user_name
				if [[ $answer == "y" ]]
				then
					usermod -u $uid -o $user_name
					echo -e "\n\t\t\t\tModify successed.\n"
				fi
				read -p "                Please input any key to continue"                                   clear
 
				;;
			2)
				read -p "        Please input new gid: " gid
				echo
				usermod -g $gid $user_name
				read -p "                Please input any key to continue"                                   clear

				;;
			3)
				read -p "        Please input new home_directory: " hd
				echo
				usermod -d $hd $user_name
				read -p "                Please input any key to continue"                                   clear
				;;
			4)
				usermod -L $user_name
				cat /etc/shadow |egrep "^$user_name:"|awk -F: '{print $2}'|egrep "^!" &>/dev/null && echo -e "\t\t\t\tLock successed.\n" ||echo -e "\t\t\t\tPlease lock again."
				read -p "                Please input any key to continue"                                   clear

				;; 
			*)
				return;;
			esac
			
		done
	else
                echo -e "\n\t\t\t   \e[31mUser \" $user_name\" do not exists.\e[0m\n"   
        fi

}
########################################################################################
# 4
delUser(){
	clear
	show
	echo
	read -p "        Please input the user_name which you want remove: " user_name
	echo
	if  id $user_name &>/dev/null 
	then
		read -p "        Confirmed to remove the user ?(y/n): " choice
		echo
		if [[ $choice == "y" ]]
		then
			read -p "        Would you want to remove the home directory ?(y/n): " answer
			echo
			if [[ $answer == "y" ]]
			then
				userdel -r $user_name &>/dev/null
			else	
				userdel $user_name &>/dev/null
			fi
			echo
			id $user_name &>/dev/null && echo -e "\t\t\t    Delete $user_name \e[31mFailed\e[0m." || echo -e "\t\t\t    Delete $user_name \e[31mSuccessed\e[0m."
		fi
	else
		echo -e "\n\t\t\t   \e[31mUser \" $user_name\" do not exists.\e[0m\n"
	fi
}
########################################################################################
# 5
 ckUIfo(){
	clear
	show
	read -p "        Please input user_name which you want to check: " user_name
	if  id $user_name &>/dev/null 
	then
		cat /etc/passwd|egrep "^$user_name:"|awk -F: '{print "\nname:  "$1"\n UID:\t"$3"\n GID:\t"$4"\nhome:\t"$6"\nShell:\t"$7}'
	else
		echo -e "\n\t\t\t   \e[31mUser \" $user_name\" do not exists.\e[0m\n"
	fi
}
########################################################################################
# 6
addGroup(){
        clear
	gshow
        read -p "        Please input the group_name: " group_name
        echo
	group=`cat /etc/group|grep "$group_name:" `
        if  [[ $group == ""  ]]
        then
                read -p "        Do you want to assgin GID ?(y/n): " choice
                echo
                if [[ $choice == "y" ]]
                then
                	read -p "        Please input the GID: " gid
                	groupadd -g $gid $group_name
                else
                	groupadd $group_name
                fi
		echo
                cat /etc/group|grep "$group_name:" &>/dev/null && echo -e "\t\t\t    Add group $group_name \e[31mSuccessed\e[0m." || echo -e "\t\t\t    Add group $group_name \e[31mFailed\e[0m."
        else
                echo -e "\n\t\t\t   \e[31mGroup \"$group_name\" already exists.\e[0m\n"
        fi
}
########################################################################################
# 7 
delGroup(){
	clear
	gshow
	read -p "        Please input the group_name which you want remove: " group_name
	echo
	group=`cat /etc/group |grep "$group_name:"`
	users=`cat /etc/group |grep "$group_name:"|awk -F: '{print $4}'`
	if [[ ! $group == "" ]] 
	then
		if [[ $users == "" ]]
		then
			read -p "        Confirmed to remove the user ?(y/n): " choice
			[[ $choice == "y" ]] && groupdel $group_name
			echo
			cat /etc/group|grep "$group_name:" &>/dev/null && echo -e "\t\t\t    Delete group $group_name \e[31mFailed\e[0m." || echo -e "\t\t\t    Delete group $group_name \e[31mSuccessed\e[0m."
		else
			echo -e "\n\t\t\t   \e[31mGroup \" $group_name\" have users, can not remove.\e[0m\n"
		fi
	else
		echo -e "\n\t\t\t   \e[31mGroup \" $group_name\" do not exists.\e[0m\n"
	fi
}
########################################################################################
# 8
ckGIfo(){
        clear
	gshow
        read -p "        Please input group_name which you want to check: " group_name
        group=`cat /etc/group |grep "$group_name:"`
	if  [[ ! $group == "" ]]
        then
                cat /etc/group|egrep "^$group_name:"|awk -F: '{print "\n  gname:\t"$1"\n    GID:\t"$3"\nmumbers:"$4"\t"}'
        else
                echo -e "\n\t\t\t   \e[31mGroup \" $group_name\" do not exists.\e[0m\n"
        fi
}
########################################################################################
show(){
	users=$(cat /etc/passwd |awk -F: '{print $1"\t\t"}')
	echo -e "\t\t\t\t\e[5;31m= = = = Users in system = = = =\e[0m"
	echo ${users[@]}
	echo
}
########################################################################################
gshow(){
	groups=$(cat /etc/group |awk -F: '{print $1"\t\t"}')
	echo -e "\t\t\t\t\e[5;31m= = = = Groups in system = = = =\e[0m"
        echo ${groups[@]}
        echo

}
########################################################################################
main(){
	while true
	do
		clear
		welcom
		read -p "	  please input the number :" choice
		case $choice in
		0)
			clear
			echo -e "\n\n\t\t\t\e[42;36m  Thank you for using, bye!  \e[0m\n\n"
			break;;
		1)
			addUser
			;;
		2)
			resetPasswd
			;;
		3)
			modify
			;;
		4)
			delUser
			;;
		5)
			ckUIfo
			;;
		6)
			addGroup
			;;
		7)
			delGroup
			;;
		8)
			ckGIfo
			;;
		*)
			echo
			echo -e "\t\t\t\e[5;31mWARNING!! Please input the right number.\e[0m\n"
			;;
		esac
		echo
		read -p "                        [Please put any key to continue]"
		
	done
}
main
