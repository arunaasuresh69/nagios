#!/bin/bash

# Update and install dependencies
sudo apt update
sudo apt install -y autoconf bc gawk dc build-essential gcc libc6 make wget unzip apache2 php libapache2-mod-php libgd-dev libmcrypt-dev libssl-dev snmp libnet-snmp-perl gettext

# Create a directory for Nagios installation
mkdir -p ~/nagios
cd ~/nagios

# Download and extract Nagios Core
wget https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz
tar -xf nagios-4.4.6.tar.gz
cd nagioscore-nagios-4.4.6

# Display current directory
pwd

echo "### 2.2 Creating the Nagios user and group"
sleep 1

# Create Nagios user and group
sudo useradd nagios
sudo groupadd nagcmd
sudo usermod -a -G nagcmd nagios

echo "### 2.3 Compiling and installing Nagios"
sleep 1

# Configure, compile, and install Nagios
sudo ./configure --with-httpd-conf=/etc/apache2/sites-enabled
sudo make all

# Install Nagios binaries, service daemon script, command mode, and configuration files
sudo make install
sudo make install-daemoninit
sudo make install-commandmode
sudo make install-config

# Install the Apache configuration for Nagios, enable required Apache modules, and restart Apache
sudo make install-webconf
sudo a2enmod rewrite cgi
sudo systemctl restart apache2

# Create a nagiosadmin user with a password
sudo htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin 123456

# Configure firewall
for svc in Apache ssh; do
  sudo ufw allow $svc
done

# Enable UFW firewall
sudo ufw enable

# Installing Nagios and NRPE plugins
sudo apt install -y monitoring-plugins nagios-nrpe-plugin

# Create a directory for server hosts configurations
sudo mkdir -p /usr/local/nagios/etc/servers

# Append configuration directory to nagios.cfg
echo "cfg_dir=/usr/local/nagios/etc/servers" | sudo tee -a /usr/local/nagios/etc/nagios.cfg > /dev/null

# Note: The following commands for editing resource.cfg and other configurations are commented out
# as they involve manual editing. Uncomment and modify as necessary.
# sudo vim /usr/local/nagios/etc/resource.cfg
# sudo echo "$USER1$=/usr/lib/nagios/plugins" >> /usr/local/nagios/etc/resource.cfg
# sudo sed -i 's/$USER1$=\/usr\/local\/nagios\/libexec/$USER1$=\/usr\/lib\/nagios\/plugins/g' /usr/local/nagios/etc/resource.cfg
