#!/bin/bash

sudo apt update
sudo apt install -y autoconf bc gawk dc build-essential gcc libc6 make wget unzip apache2 php libapache2-mod-php libgd-dev libmcrypt-dev make libssl-dev snmp libnet-snmp-perl gettext
sudo mkdir ~/nagios -p
sudo cd  ~/nagios
sudo wget https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz
sudo tar -xf nagios-4.4.6.tar.gz
sudo cd nagioscore-nagios-*/
sudo pwd

echo "###2.2	Create the Nagios user and group using the below commands"
sleep 1

sudo useradd nagios
sudo groupadd nagcmd
sudo usermod -a -G nagcmd nagios


echo "### 2.3	Compile and install Nagios"
sleep 1

sudo ./configure --with-httpd-conf=/etc/apache2/sites-enabled
sudo make all

### 2.4	Run the following commands to install Nagios binaries, service daemon script, and the command mode.
sudo make install
sudo make install-daemoninit
sudo make install-commandmode
sudo make install-config

#### 2.5	Install the Apache configuration for Nagios and activate the mod_rewrite and mode_cgi modules and restart the apache service
sudo make install-webconf
sudo a2enmod rewrite cgi
sudo service apache2 restart

#### 2.6	As you have installed the Nagios Core 4.4.6. Now create nagiosadmin user
sudo htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin 123456

#### 2.7	Enter the password of your choice. You need to remember it as this will be used to login to nagios later

#### 2.8	For the firewall configuration, run the command below
for svc in Apache ssh
do
sudo ufw allow $svc
done

#### 2.9	To start the UFW firewall service and add it to the system boot, run
sudo ufw enable

#### Step 3: Installing Nagios and NRPE plugins

#### 3.1	Run the following command:

sudo apt install monitoring-plugins nagios-nrpe-plugin

#### 3.2	Now, go to the nagios installation directory /usr/local/nagios/etc and create a new directory for storing all server hosts configuration
sudo cd /usr/local/nagios/etc
sudo mkdir -p /usr/local/nagios/etc/servers
#### 3.3	Edit the Nagios configuration nagios.cfg using the vim editor
#sudo vim nagios.cfg

#### 3.4	Press i and uncomment the cfg_dir option that will be used for storing all server hosts configurations
sudo echo "cfg_dir=/usr/local/nagios/etc/servers" >> nagios.cfg
	 

#### sudo vim resource.cfg 3.6	Define the Nagios Monitoring Plugins path by changing the default configuration as shown below
# sudo echo "$USER1$=/usr/lib/nagios/plugins" >> resource.cfg
# sudo sed -i 's/$USER1$=\/usr/\local\/nagios/\libexec/$USER1$=\/usr\/lib\/nagios\/plugins\/g' resource.cfg

