This is a simple adblocker that uses dnsmasq to block dns requests to specifis domains. 
The domain list are downloaded from various sources see black_list_updater.py 

Tested on ubuntu 16.04

Usage:
<ul>
  <li>1- Install dnsmasq if its not alerdy installed (sudo apt-get install dnsmasq should do it)</li>
  <li>2- download the source files(black_list_updater.py,blocker.sh,hosts.txt,user_list.txt) to a directory and cd into that directory</li>
  <li>3- sudo chmod +x ./blocker.sh</li> 
  <li>4- sudo ./blocker.sh</li> 
</ul>
<br>
Now follow the instructions. 
<br>
(NOTE! <b> Please check the source code before running the scripts. Dont just run it, try to understand it </b> )
