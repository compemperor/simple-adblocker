#This file walks out to the great internet and updates the blocked domains list

# See `https://github.com/StevenBlack/hosts` for details
#compemperor

import urllib2
import re

##StevenBlack's list
steve_ = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"

##MalwareDomains
malw_ = "https://mirror1.malwaredomains.com/files/justdomains"

##Cameleon
came_ = "http://sysctl.org/cameleon/hosts"

##Zeustracker
zeus_ = "https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist"

##Disconnect.me Tracking
simtrck_ = "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"

##Disconnect.me Ads
simad_ ="https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"

##Hosts-file.net
ad_serv_ = "https://hosts-file.net/ad_servers.txt"


def Update_steve_():
    data = ""
    try:
        print "Updating Steves list: %s" %steve_
        data=urllib2.urlopen(steve_).read()
        data = data.replace("127.0.0.1", "")
        data = data.replace('0.0.0.0',"")
        data = data.replace('localhost.localdomain',"")
        data = data.replace('255.255.255.255',"")
        data = data.replace('broadcasthost',"")
        data = data.replace('localhost',"")
        data = data.replace('local',"")
        data = data.replace('::1',"")
        data = re.sub(r"fe80%lo0", "", data)


    except Exception,e:
        print "Can not get StevenBlac's list %s" %e
    finally:
        return data

def Update_malw_():
    data = ""
    try:
        print "Updating Malware domains: %s" %malw_
        data=urllib2.urlopen(malw_).read()

    except Exception,e:
        print "Can not get MalwareDomains list %s" %e
    finally:
        return data

def Update_came_():
    data = ""
    try:
        print "Updating Cameleon: %s" %came_
        data=urllib2.urlopen(came_).read()
        data = data.replace("127.0.0.1","")

    except Exception,e:
        print "Can not get Cameleon list %s" %e
    finally:
        return data

def Update_zeus_():
    data = ""
    try:
        print "Updating Zeustracker: %s" %zeus_
        data=urllib2.urlopen(zeus_).read()

    except Exception,e:
        print "Can not get Zeustracker list %s" %e
    finally:
        return data

def Update_simtrck_():
    data = ""
    try:
        print "Updating disconnect.me Tracking: %s" %simtrck_
        data=urllib2.urlopen(simtrck_).read()

    except Exception,e:
        print "Can not get Disconnect.meTracks list %s" %e
    finally:
        return data

def Update_simad_():
    data = ""
    try:
        print "Updating disconnect.me Ads: %s" %simad_
        data=urllib2.urlopen(simad_).read()

    except Exception,e:
        print "Can not get Disconnect.meAds list %s" %e
    finally:
        return data

def Update_ad_serv_():
    data = ""
    try:
        print "Updating Host-file.net: %s" %ad_serv_
        data=urllib2.urlopen(ad_serv_).read()
        data = data.replace("127.0.0.1", "")

    except Exception,e:
        print "Can not get Hostfile.net list %s" %e
    finally:
        return data

def Update_user_list():
    data = ""
    try:
        print "Updating user list: ./user_list.txt"
        user_list= open("user_list.txt",'a+')
        data = user_list.read()
        user_list.close()
    except Exception, e:
        print "can not update the user list %s" %e
    finally:
        return  data

def configure_white_list(data):
    white_list = open("white_list.txt",'a+')
    white_list_data = white_list.read()

    for domain in white_list_data.split('\n') :
        data = data.replace(domain,"")
    return data


def Join_and_save():
    data = ""
    try:
        host_file= open("hosts.txt","w+")
        data = Update_steve_() + Update_malw_() + Update_came_() + Update_zeus_() \
        + Update_simtrck_() + Update_simad_() + Update_ad_serv_() + Update_user_list()

        print "Configuring the white list..."
        data = configure_white_list(data)

        print "Formating the hosts file...."
        data = re.sub(r'#.*', "", data)

        reformatted = ""
        for li in data.split('\n'):
            if li.strip():
                reformatted += li + '\n'


        host_file.write(reformatted)
        host_file.close()
    except Exception, e:
        print "Something went wrong when writing host.txt %s" %e

if __name__ == '__main__':
    print "Updating host list this might take a while...."
    Join_and_save()
   
