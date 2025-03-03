#!/bin/bash



#1.1 Install the needed applications and 1.2 If the applications are already installed, don’t install them again
function INSTALL() {
	LOG
    # Array of package names
    packages=("sshpass" "tor" "nipe" "whois" "nmap")

    # Iterate through the array
    for package in "${packages[@]}"; do
        if dpkg -l | grep -q "^ii  $package"; then
            echo "User: $USER | Date: $DATE | $package is already installed.  " >> logs.log
        else
            echo "User: $USER | Date: $DATE | $package is not installed. Installing now... " >> logs.log 
            sudo apt-get install "$package" -y
        fi
    done
}

# 1.3 Check if the network connection is anonymous; if not, alert the user and exit.
function ANONYMOUS_CHECK() {
	LOG
    IP=$(curl -s ifconfig.me)  # Silent mode to avoid output
    LOCATION=$(geoiplookup "$IP" | awk '{print $4}' | sed 's/,//g')

    if [ "$LOCATION" == "RW" ]; then 
        echo "User: $USER | Date: $DATE | You are not anonymous! Exiting now...." >> logs.log
        #log_message "Not anonymous! Exiting."
        exit 1
    else
		# 1.4 If the network connection is anonymous, display the spoofed country name.
        echo "User: $USER | Date: $DATE | You are anonymous! Spoofed country: $LOCATION " >> logs.log
        #log_message "Anonymous: Spoofed country is $LOCATION."
        ADDR 
    fi
}

#1.5 Allow the user to specify the address to scan via remote server; save into a variable.
function ADDR()
{
	LOG
	read -p "User: $USER | Date: $DATE | Enter the address to Scan: " ADDRESS >> logs.log
	echo "The directories on hacked Computer " >> logs.log
	sshpass -p "kali" ssh -o StrictHostKeyChecking=no kali@192.168.186.135 'ls' >> logs.log
	HACK
	
}
 function HACK()
 {
	 #Dsiplaying the haccked public IP
	 IP=$(curl -s ifconfig.me)
	 echo "User: $USER | Date: $DATE | The hacked IP address is: $IP" >> logs.log
	 
	 
	 
	 #Displaying the country of the hacked IP
	 CNTRY=$(curl -s https://ipinfo/$IP/country)
	 echo " User: $USER | Date: $DATE | The hacked IP is in: $CNTRY" >> logs.log
	 
	 #Displaying Uptime of the hacked IP\
	 UPTIME=$(uptime -p)
	 echo "User: $USER | Date: $DATE | The computer is running for: $UPTIME" >> logs.log
	 
	 # 2.2 Get the remote server to check the Whois of the given address.
	 
     WHO=$(whois $IP)
     echo "User: $USER | Date: $DATE | The whois report is below: $WHO" >> logs.log
     
     # Get the remote server to scan for open ports on the given address.
     
     PORT=$(nmap $IP)
     echo "User: $USER | Date: $DATE | Open ports are: $PORT" >> logs.log

	 SAVE
 }
 
 
 
 
 # 3.1 Save the Whois and Nmap data into files on the local computer.
 function SAVE()
 {
	 echo "WHOIS REPORT" >> hacked_logs.txt
	 echo $WHO >> hacked_logs.txt
	 echo "NMAP REPORT" >> hacked_logs.txt
	 
	 echo $PORT >> hacked_logs.txt
	 POK
 }
 
 
 # Keeping logs
 function LOG()
 {
	 USER=$(whoami)
	 DATE=$(date '+%Y-%m-%d %H:%M:%S') 
 }
 
 
 
 
 # Poking a hakced computer
 function POK()
 {
		echo "You were hacked, next time keep security" > hacked.txt
}

#Call installation fucntion
INSTALL
#CAll anonymous check
ANONYMOUS_CHECK

