# Remote Control Project

This project provides a set of bash scripts to remotely control and monitor a computer. The scripts include functionalities such as installing necessary applications, checking for anonymous network connections, scanning remote servers, and logging various details.

## Features

- **Install Required Applications**: Automatically installs required applications (`sshpass`, `tor`, `nipe`, `whois`, `nmap`).
- **Check Anonymous Network Connection**: Verifies if the network connection is anonymous and logs the spoofed country.
- **Specify Address to Scan**: Allows user to input an address to scan via a remote server.
- **Remote Hacking**: Displays directories, IP address, country, uptime, WHOIS information, and open ports of the hacked computer.
- **Logging**: Keeps detailed logs of all actions performed.

## Usage

1. **Install the Needed Applications**: 
   ```bash
   function INSTALL() {
       # Array of package names
       packages=("sshpass" "tor" "nipe" "whois" "nmap")
       for package in "${packages[@]}"; do
           if dpkg -l | grep -q "^ii  $package"; then
               echo "$package is already installed."
           else
               sudo apt-get install "$package" -y
           fi
       done
   }
   ```

2. **Check Anonymous Network Connection**: 
   ```bash
   function ANONYMOUS_CHECK() {
       IP=$(curl -s ifconfig.me)
       LOCATION=$(geoiplookup "$IP" | awk '{print $4}' | sed 's/,//g')
       if [ "$LOCATION" == "RW" ]; then 
           echo "You are not anonymous! Exiting now...."
           exit 1
       else
           echo "You are anonymous! Spoofed country: $LOCATION"
           ADDR 
       fi
   }
   ```

3. **Specify Address to Scan**: 
   ```bash
   function ADDR() {
       read -p "Enter the address to Scan: " ADDRESS
       echo "The directories on hacked Computer"
       sshpass -p "kali" ssh -o StrictHostKeyChecking=no kali@192.168.186.135 'ls'
       HACK
   }
   ```

4. **Remote Hacking**: 
   ```bash
   function HACK() {
       IP=$(curl -s ifconfig.me)
       echo "The hacked IP address is: $IP"
       CNTRY=$(curl -s https://ipinfo/$IP/country)
       echo "The hacked IP is in: $CNTRY"
       UPTIME=$(uptime -p)
       echo "The computer is running for: $UPTIME"
       WHO=$(whois $IP)
       echo "The whois report is below: $WHO"
       PORT=$(nmap $IP)
       echo "Open ports are: $PORT"
       SAVE
   }
   ```

5. **Save Logs**: 
   ```bash
   function SAVE() {
       echo "WHOIS REPORT" >> hacked_logs.txt
       echo $WHO >> hacked_logs.txt
       echo "NMAP REPORT" >> hacked_logs.txt
       echo $PORT >> hacked_logs.txt
       POK
   }
   ```

6. **Keep Logs**: 
   ```bash
   function LOG() {
       USER=$(whoami)
       DATE=$(date '+%Y-%m-%d %H:%M:%S')
   }
   ```

7. **Poking a Hacked Computer**: 
   ```bash
   function POK() {
       echo "You were hacked, next time keep security" > hacked.txt
   }
   ```

8. **Execute the Script**: 
   ```bash
   INSTALL
   ANONYMOUS_CHECK
   ```

## Logs

The script keeps logs of all actions performed in `logs.log` and `hacked_logs.txt`.

