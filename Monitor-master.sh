#!/bin/bash
#author roach
#time 2017/1/23
#version 1.0.1
#

echo -e "\033[31m \033[1m"
EMAIL=email.txt
DATE=`date`
EAMIL_COM=sky872401171@126.com

cat << EOF
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++Welcome to use auto monitor system+++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
EOF
if [[ -z $1 ]]; then
	#statements
	echo -e "\033[32mUsage: { sh $0 nginx | mysql | list.txt}\033[0m"
	echo
	exit 1
fi
sleep 2
M_IPADDR=`ifconfig eth1|grep "Bcast"| awk '{print $2 }'|cut -d ":" -f 2`

if [[ -f "$1" -a "$1" == "list.txt" ]]; then
	#statements
	for i in `cat list.txt|grep -v "#"`
		do
			count=`ps -ef|grep $i|grep -v grep|grep -v "email"|head -l |wc -l`
			if [[ $count -ne 1 ]]; then
				#statements
				cat >>$EMAIL <<EOF
				******************Server Monitor**********************
				通知类型： 故障
				
				服务: $i
				
				主机：$M_IPADDR
				
				状态：警告
				
				日期/时间：$DATE
				
				额外信息：
				
				CRITICAL - $i Server Connection Refused,Please Check.
				******************************************************
EOF
				dos2unix $EMAIL
				echo -e "\033[32mThe Monitor $i warning,Please Check.\033[0m"
				mail -s "$M_IPADDR $i Warning" $EMAIL_COM < $EMAIL >>/dev/null 2>&1
			else
				echo -e "\033[32mThe Monitor $i Server 200 ok!\033[0m"
			fi
			echo -e "\n\033[32m-----------------------------------------------\033[1m"
		done
else
	count=`ps -ef|grep $i|grep -v grep|grep -v "email"|head -l |wc -l`

	if [[ $count -ne 1 ]]; then
		#statements
		cat >$EMAIL <<EOF
		******************Server Monitor**********************
		通知类型： 故障

		服务: $i

		主机：$M_IPADDR

		状态：警告

		日期/时间：$DATE

		额外信息：

		CRITICAL - $i Server Connection Refused,Please Check.
		******************************************************
EOF
		dos2unix $EMAIL
		echo -e "\033[32mThe Monitor $i warning,Please Check.\033[0m"
		mail -s "$M_IPADDR $i Warning" $EMAIL_COM < $EMAIL >>/dev/null 2>&1
	else
		echo -e "\033[32mThe Monitor $i Server 200 ok!\033[0m"
	fi
	echo -e "\n\033[32m-----------------------------------------------\033[1m"
	echo "Done."
fi