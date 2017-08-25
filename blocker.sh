#!/bin/bash 

cat <<BeginOfArt

  ________  __     ___      ___    _______   ___       _______           __       ________   _______   ___        ______    ______   __   ___  _______   _______   
 /"       )|" \   |"  \    /"  |  |   __ "\ |"  |     /"     "|         /""\     |"      "\ |   _  "\ |"  |      /    " \  /" _  "\ |/"| /  ")/"     "| /"      \  
(:   \___/ ||  |   \   \  //   |  (. |__) :)||  |    (: ______)        /    \    (.  ___  :)(. |_)  :)||  |     // ____  \(: ( \___)(: |/   /(: ______)|:        | 
 \___  \   |:  |   /\\  \/.    |  |:  ____/ |:  |     \/    |         /' /\  \   |: \   ) |||:     \/ |:  |    /  /    ) :)\/ \     |    __/  \/    |  |_____/   ) 
  __/  \\  |.  |  |: \.        |  (|  /      \  |___  // ___)_       //  __'  \  (| (___\ ||(|  _  \\  \  |___(: (____/ // //  \ _  (// _  \  // ___)_  //      /  
 /" \   :) /\  |\ |.  \    /:  | /|__/ \    ( \_|:  \(:      "|     /   /  \\  \ |:       :)|: |_)  :)( \_|:  \\        / (:   _) \ |: | \  \(:      "||:  __   \  
(_______/ (__\_|_)|___|\__/|___|(_______)    \_______)\_______)    (___/    \___)(________/ (_______/  \_______)\"_____/   \_______)(__|  \__)\_______)|__|  \___) 
compemperor                                                                                                                                                    1.1

BeginOfArt
 
cat <<BeginOfOpt

Welcome to simple adblocker, this is nothing more than
a script that uses dnsmasq and python to block ads/malware domains. 
The script requiers that dnsmasq and python 2.7.x are installed, it may/will change your existing dnsmasq
confgurations.(apt-get install dnsmasq should do it)

start - start/update dnsmasq and populate it with the latest blocked domain names, run it once in awhile to update the domain list 

stop - stop dnsmasq and remove the firewall rules 

abort - you may guess this one

BeginOfOpt

#------------------Global declartions---------------------

#Stop/start dnsmasq 
stopcmd='/etc/init.d/dnsmasq stop'
startcmd='/etc/init.d/dnsmasq start'
statuscmd='/etc/init.d/dnsmasq status'

#Update the hosts 
update_hosts='python ./black_list_updater.py'

out_interface=$(route | grep '^default' | grep -o '[^ ]*$')

#redirect traffic to this ip  
catcherip='127.0.0.1'

#dnsmasq default configuration file
configfile=/etc/dnsmasq.conf 

#just a temp file to save domains to
tmpconffile="/tmp/.dnsmasq.conf.$$"

#will hold the blocked domains, this file is alterd by the python code
hosts_file="./hosts.txt"



# Add/delete firewall/iptabel rules to drop the packets forwarded to the catcher 
firewall_rule_check="iptables -C OUTPUT -o $(echo out_interface) -p udp --dport 53  -d 127.0.0.1 -j DROP"
firewall_rule_add="iptables -A OUTPUT -o $(echo out_interface) -p udp --dport 53  -d 127.0.0.1 -j DROP"
firewall_rule_delete="iptables -D OUTPUT -o $(echo out_interface) -p udp --dport 53  -d 127.0.0.1 -j DROP"

#---------------------------Logic---------------------------

#Check if the hosts file exist
function check_host_file
{ 
	if [ ! -s $1 ] 
	then		
		echo "hosts file '$1' either doesn't exist or is empty; quitting"
		exit 
	fi 
}

#Populate dnsmasq 
function dnsmasq_config
{
	cat $1 | grep -v "address=" > $2

	while read line; do
		ADDRESS="/${line}/${3}"
		echo "address=\"${ADDRESS}\"" >> $2
	done < $4

	mv $2 $1 

}


echo "Please select an option:"
select opt in "start" "stop" "status" "abort"
do
	if [ $opt == "abort" ]
	then
		echo "goodbye..."
		break
	
	elif [ $opt == "status" ]
	then
		$statuscmd
		break

	elif [ $opt == "start" ] 
   	then 
		#stop dnsmasq if it is runing
		$stopcmd
		echo "Adding firewall rules..."
		#check if the rule exits
		$firewall_rule_check 2> /dev/null
		if [ $? -eq 1 ]
		then
			#add firewall rules
			$firewall_rule_add
		fi
		#update the domain list
		$update_hosts
		#check if the hostfile is there
		check_host_file $hosts_file
		#populate dnsmasq 
		dnsmasq_config $configfile $tmpconffile $catcherip $hosts_file
		#start dnsmasq
		$startcmd
		echo "Done..."
		break


	elif [ $opt == "stop" ] 
   	then 
		#stop dnsmasq if it is runing
		$stopcmd
		echo "Deleting firewall rules..."
		#check if the rule exits
		$firewall_rule_check 2> /dev/null
		if [ $? -eq 0 ]
		then
			#delete the firewall rule
			$firewall_rule_delete
		fi
		
		echo "Done..."
		break
	fi
done 
