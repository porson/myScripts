#!/bin/bash
menu(){
	clear
	echo
	echo -e "\t\t\t\e[33m1.View log by date."
	echo
	echo -e "\t\t\t\e[34m2.View log by exit."
	echo
	echo -e "\t\t\t\e[33m3.View log by length of the breaking time."
	echo
	echo -e "\t\t\t\e[34m4.iew log by IP."
	echo
	echo -e "\t\t\t\e[33m5.View log by down times."
	echo
	echo -e "\t\t\t\t\e[31mInput 'q' to quit.\e[0m"
	echo
}
#########
byDate(){
	while true
	do
		clear
			echo
		read -p "Please input the date like '$(date +%F)':" v_date
		clear
		more log/log_"$v_date".txt;
		echo
		read -s -n1 -p "Do you want to continue [Y/N]?" answer
		case $answer in
		Y|y)
			continue
			;;
		N|n)
			break
			;;
		*)
			continue
			;;
		esac 
	done
}
##############
byExit(){
	while true
        do
		clear
                logs=$(find log/ -type f)
		for i in ${logs[@]}
		do
			nr=$(awk '/Monitor/{print NR}' $i)
			for q in ${nr[@]}
			do
				sed -n "$(($q-1)),$(($q+2))p" $i
			done
		done

                echo
                read -s -n1 -p "Do you want to continue [Y/N]?" answer
                case $answer in
                Y|y)
                        continue
                        ;;
                N|n)
                        break
                        ;;
                *)
                        continue
                        ;;
                esac
        done
	
}
#############
byLength(){
	while true
        do
                clear
		read -p "Please input the minimum length of time(second):" mintime
                logs=$(find log/ -type f)
                for i in ${logs[@]}
                do
                        nr=$(awk '/seconds/&&$4>'$mintime'{print NR}' $i)
                	for q in ${nr[@]}
			do
				[ ! -n "$q" ]&&echo "Can not find the record"\
				||sed -n "$(($q-2)),$(($q+1))p" $i
				echo
			done
                done

                echo
                read -s -n1 -p "Do you want to continue [Y/N]?" answer
                case $answer in
                Y|y)
                        continue
                        ;;
                N|n)
                        break
                        ;;
                *)
                        continue
                        ;;
                esac
        done
}
#############
byIP(){
while true
        do
                clear
                read -p "Please input the IPaddr:" ipaddr
                [[ "$ipaddr" = "" ]]&&echo "Please input the right IP!"&&(read;continue)
		logs=$(find log/ -type f)
                for i in ${logs[@]}
                do
                        nr=$(awk '/'$ipaddr/'{print NR}' $i)
                        for q in ${nr[@]}
                        do	
                                [ ! -n "$q" ]&&echo "Can not find the record"\
                                ||sed -n "$(($q)),$(($q+3))p" $i
                        done
                done

                echo
                read -s -n1 -p "Do you want to continue [Y/N]?" answer
                case $answer in
               Y|y)
                        continue
                        ;;
                N|n)
                       break
                        ;;
                *)
                        continue
                        ;;
                esac
       done
}
#############
byTimes(){
	while true
        do
                clear
                read -p "Please input the minimum times:" times
                logs=$(find log/ -type f)
                for i in ${logs[@]}
                do
                        nr=$(awk '/times/&&$6>='$times'{print NR}' $i)
                        for q in ${nr[@]}
                        do
                                [ ! -n "$q"  ]&&echo "Can not find the record"\
                                ||sed -n "$(($q-2)),$(($q+1))p" $i
                        done
                done

                echo
                read -s -n1 -p "Do you want to continue [Y/N]?" answer
                case $answer in
               Y|y)
                        continue
                        ;;
                N|n)
                        break
                        ;;
                *)
                        continue
                        ;;
                esac
       done

}	
#############
while true
do
	menu
	read -s -n1 -p "Please input the number :" choice
	case $choice in
	1)	
		byDate;;
	2)
		byExit;;
	3)
		byLength;;
	4)
		byIP;;
	5)
		byTimes;;
	Q|q)
		echo
		echo -e "\t\t\tThanks for using"
		exit ;;
	*)
		;;
	esac
done
