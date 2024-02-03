# NagiOS (https://github.com/manikcloud/DevOps-Tutorial/tree/main/9.1-NagiOS)

# Nagios Monitoring Tool Installation and Configuration Guide

This guide provides detailed instructions on how to install Nagios, a powerful monitoring tool, along with Nagios Remote Plugin Executor (NRPE) plugins for monitoring host resources via the network. It covers the installation of Nagios Core 4.4.6 on Ubuntu, setting up package dependencies, and configuring Nagios for host monitoring.

## Prerequisites

- A server running Ubuntu
- Sudo or root privileges

## Installation Steps

### Step 1: Installing Package Dependencies

Update your package list and install the necessary dependencies to prepare for Nagios installation.

### Step 2: Installing Nagios Core 4.4.6

#### 2.1 Download and Extract Nagios Core

Download the Nagios Core source code and extract it.

#### 2.2 Create Nagios User and Group

Create a dedicated user and group for Nagios to ensure secure operations.

#### 2.3 Compile and Install Nagios

Compile the Nagios source code and install it along with its daemon and command mode.

#### 2.4 Configure Apache and Nagios

Configure Apache to serve the Nagios web interface and ensure the necessary modules are enabled.

#### 2.5 Create nagiosadmin User for Web Interface

Set up a `nagiosadmin` user for accessing the Nagios web interface.

#### 2.6 Configure Firewall for Nagios

Adjust the firewall settings to allow traffic for Nagios and its web interface.

### Step 3: Installing Nagios and NRPE Plugins

Install the NRPE plugins required for monitoring remote hosts.

#### 3.2 Configure Nagios for Monitoring Hosts

Prepare Nagios for monitoring hosts by configuring its main and resource configuration files.

#### 3.3 Update Plugin Configuration

Ensure the Nagios plugins are correctly defined in the resource configuration.

#### 3.4 Configure Contact Information

Update the contact information in Nagios to receive alerts.

#### 3.5 Add check_nrpe Command Definition

Define the `check_nrpe` command in Nagios for executing remote plugins.

#### 3.6 Start and Enable Nagios Service

Enable and start the Nagios service, ensuring it runs at boot.

#### 3.7 Final Steps

Restart Apache to apply the new Nagios configuration and access the web interface.

## Accessing Nagios Web Interface

Navigate to the Nagios web interface using your server's IP address and log in with the `nagiosadmin` user credentials to access the dashboard.

## Conclusion

Following these steps, you will have Nagios Core 4.4.6 installed and configured on your Ubuntu server for host monitoring. Further customization and host addition can be done according to your monitoring needs.

---
### Nagios installation and host monitoring docker and ansible



## How to Install Nagios Monitoring Tool

```
Steps to be followed:
1.	Installing package dependencies
2.	Installing Nagios Core 4.4.6
3.	Installing Nagios and NRPE plugins

Step 1: Installing package dependencies
1.1	Install the package dependencies using the following commands:

sudo apt update
sudo apt install -y autoconf bc gawk dc build-essential gcc libc6 make wget unzip apache2 php libapache2-mod-php libgd-dev libmcrypt-dev make libssl-dev snmp libnet-snmp-perl gettext


Step 2: Installing Nagios Core 4.4.6
2.1	Download the Nagios Core source code
cd ~/
wget https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz
tar -xf nagios-4.4.6.tar.gz
cd nagioscore-*/

2.2	Create the Nagios user and group using the below commands

sudo useradd nagios
sudo groupadd nagcmd
sudo usermod -a -G nagcmd nagios
2.3	Compile and install Nagios
sudo ./configure --with-httpd-conf=/etc/apache2/sites-enabled
sudo make all

2.4	Run the following commands to install Nagios binaries, service daemon script, and the command mode.
sudo make install
sudo make install-daemoninit
sudo make install-commandmode
sudo make install-config

2.5	Install the Apache configuration for Nagios and activate the mod_rewrite and mode_cgi modules and restart the apache service
sudo make install-webconf
sudo a2enmod rewrite cgi
sudo service apache2 restart

2.6	As you have installed the Nagios Core 4.4.6. Now create nagiosadmin user
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

2.7	Enter the password of your choice. You need to remember it as this will be used to login to nagios later

2.8	For the firewall configuration, run the command below
for svc in Apache ssh
do
sudo ufw allow $svc
done

2.9	To start the UFW firewall service and add it to the system boot, run
sudo ufw enable

Step 3: Installing Nagios and NRPE plugins

3.1	Run the following command:

sudo apt install monitoring-plugins nagios-nrpe-plugin

3.2	Now, go to the nagios installation directory /usr/local/nagios/etc and create a new directory for storing all server hosts configuration
cd /usr/local/nagios/etc
sudo mkdir -p /usr/local/nagios/etc/servers

3.3	Edit the Nagios configuration nagios.cfg using the vim editor
sudo vim nagios.cfg

3.4	Press i and uncomment the cfg_dir option that will be used for storing all server hosts configurations
cfg_dir=/usr/local/nagios/etc/servers
	 

3.5	Save and close. Now edit the configuration file resource.cfg
sudo vim resource.cfg

3.6	Define the Nagios Monitoring Plugins path by changing the default configuration as shown below
$USER1$=/usr/lib/nagios/plugins
 

3.7	Save and close the file. Now edit the objects/contacts.cfg file and add the nagios admin email contacts
sudo vim objects/contacts.cfg

3.8	Change the email address with your own
define contact{
        ......
        email             <YourEmailId>
}

3.9	 Save and close. Edit the objects/commands.cfg file
sudo vim objects/commands.cfg

3.10	Add the following configuration to the end of the file
define command{
       command_name check_nrpe
       command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}

3.11	Save and close, and the Nagios core configuration has been completed. Run the following commands:
sudo systemctl start nagios
sudo systemctl enable nagios

3.12	The Nagios service should be up and running, check using the following command:
sudo systemctl status nagios

 

3.13	Restart the Apache service to apply a new Nagios configuration
sudo systemctl restart apache2

3.14	Now open your web browser and type the server IP address following the nagios URL 
http://localhost/nagios/

3.15	Now you will have to log in with the user nagiosadmin and type your password

 
3.16	You will get the Nagios Dashboard as shown below:
 
3.17	You've installed Nagios on the Ubuntu server.
```
# Adding host remote server details in host.cfg

### vim /usr/local/nagios/etc/servers/host.cfg
```

define host {
   use linux-server
   host_name nginx
   alias nginx Host
   address 172.17.0.2
   register 1
}

define service {
   host_name nginx
   service_description PING
   check_command check_ping!100.0,20%!500.0,60%
   max_check_attempts 2
   check_interval 2
   retry_interval 2
   check_period 24x7
   check_freshness 1
   contact_groups admins
   notification_interval 2
   notification_period 24x7
   notifications_enabled 1
   register 1
}
```
- Restart the nagios service 
 ```
 sudo service nagios restart

 ``` 



