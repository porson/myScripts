#!/bin/bash
#service_monitor
#Create by Leepx

#check_the_log_service_and_configure
if ! egrep "local6" /etc/rsyslog.conf &>/dev/null
then
	echo "local6.* /var/log/leepx_mo.log" >> /etc/rsyslog.conf
	echo "local6.alert *" >> /etc/rsyslog.conf
	service rsyslog restart &>/dev/null
fi

#function_service_monitor
monitor(){
if service $1 status &>/dev/null
then
	echo "$1_STATUS_CLEAR" | logger -it "$1_STATUS" -p local6.info
else
	echo "$1_NOT_RUNNING" | logger -it "$1_SERVICE_DOWN" -p local6.notice
	
	if ! service $1 restart &>/dev/null
	then
		echo "$1_CAN_NOT_RESTART" | logger -it "$1_SERVICE_ERROR" -p local6.alert
	else
		echo "$1_RUNNING_AGAIN" | logger -it "$1_STATUS_CLEAR_NOTICE" -p local6.notice
	fi
fi
}


#function_local_yum_monitor
local_yum_monitor(){
yum clean all &>/dev/null
if yum list &>/dev/null
then
	 echo "YUM_STATUS_CLEAR" | logger -it "YUM_STATUS" -p local6.info
else
	echo "YUM_STATUS_ERROR" | logger -it "YUM_STATUS_WRONG" -p local6.alert
	bash yum_install.sh
fi
}

#function_lograte
my_lograte(){
[ -d /backup ]||mkdir /backup
if ! [ -f /etc/logrotat.d/monitor ]
then
	echo \
"/var/log/leepx_mo.log {
	rotate 4
	weekly
	dateext
    	create
	prerotate
        	/bin/cp -n /var/log/leepx_mo.log-* /backup/
	endscript
}" >/etc/logrotate.d/monitor
fi
#logrotate -vf /etc/logrotate.d/monitor &>/dev/null
}


if [ -f ./monitor.conf ]
then
	conf=(`cat ./monitor.conf |egrep -v "#|^$|^yum" `)
	for i in ${conf[@]}
	do
		monitor $i &
	done
	if cat ./monitor.conf|egrep "^yum_check=1$" &>/dev/null
	then
		local_yum_monitor
	fi		
else
	echo -e "#[SERVICE_NAME]\nhttpd\nmysqld\n#[YUM]\nyum_check=1" > monitor.conf
fi
my_lograte
