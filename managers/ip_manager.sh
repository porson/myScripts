#!bin/bash
#author:leepx
source net_stat.sh 
#show_ifcfgs
show_ifcfgs(){
	#一定注意数组的定义形式
	ifcfgs=($(ls /etc/sysconfig/network-scripts/|grep "ifcfg-*"))
	
	if [[ "${#ifcfgs[@]}" == "1" ]]
	then
		echo -e "There is ${#ifcfgs[@]} ifcfg file in your host:"
	elif [[ "${#ifcfgs[@]}" > "1" ]]
	then
		echo -e "There are ${#ifcfgs[@]} ifcfg files in your host:"
	else
		echo -e "Sorry,you don't have any files."
	fi
	
	for i in ${!ifcfgs[@]}
	do
		echo -en "${ifcfgs[i]}\t"
	done
	echo
}
ip_check(){
	ip_reg="(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])"
	if echo "$1" |egrep "\b$ip_reg\b" &>/dev/null
	then
		return 0
	else
		return 1
	fi
}
in_use(){
	if ping -c 3 -i 0.2 -W 1 $1 &>/dev/null
	then
		return 0
	else
		return 1
	fi
}
show_ip(){
	if [[ "$ifcfg" == "lo" ]]
        then
                ip add |grep "inet\ "|grep "lo$"|awk '{print$5":"$2}'
        else
        	ip add |grep "inet\ "|grep "$ifcfg$"|awk '{print$7":"$2}'
        fi
}
modefiy(){
	
	if grep "$1" $ifcfg_loc &>/dev/null
	then
		sed -i "/$1/c $1=$2" $ifcfg_loc
	else
		echo "$1=$2" >> $ifcfg_loc
	fi	
		
}
modefiy_IP(){
	show_ip
	read -p "Please input the IPADDR:" new_ip
	if ! ip_check $new_ip
	then
		echo "Please enter the IPADDR correctly"
		continue
	elif in_use $new_ip
	then
		echo "IP address has been used"
		continue
	else
		modefiy "IPADDR" $new_ip
	fi
}
modefiy_MASK(){
        read -p "Please input the NETMASK:" new_mask
       	if ! ip_check $new_mask
	then
		echo "Please enter the NETMASK correctly"
		continue
	else
		modefiy "NETMASK" $new_mask
	fi
}
modefiy_DNS(){
	read -p "Please input the DNS like (1-6):" dns_name
	dns_name="DNS$dns_name"
	if ! echo "$dns_name"|egrep "DNS[1-6] &>/dev/null"
	then
		echo "Please enter the right number!"
		continue
	fi	
	read -p "Please input the DNS:" new_dns
	if ip_check $new_dns
	then
        	modefiy "$dns_name" $new_dns
	else
		echo "Please enter the $dns_name correctly"
		continue
	fi
}
modefiy_GATEWAY(){
	
	read -p "Please input the GATEWAY:" new_gway
        if ! ip_check $new_gway
        then
                echo "Please enter the GATEWAY correctly"
                continue
        else
                modefiy "GATEWAY" $new_gway
		if ! in_use $new_gway
		then
			echo -e "\nThe GATEWAY is offline.\n"
		fi
	fi
}
#此处仅演示各个函数的功能，交互比较差，如需要请自行改进
main(){
while true
do
	clear
	net_stat_mo	
	show_ifcfgs
	read -p "Please in put the interface name like \"eth0\":" ifcfg

	if ! show_ifcfgs|grep "$ifcfg" &>/dev/null
	then
		echo "Please check the file name"
		continue		   	
	fi	
	ifcfg_loc="/etc/sysconfig/network-scripts/ifcfg-$ifcfg"
	modefiy_IP
	modefiy_MASK
	modefiy_GATEWAY
	modefiy_DNS
	show_ip
	ifdown $ifcfg
	ipup $ifup
	read
done
}
main
