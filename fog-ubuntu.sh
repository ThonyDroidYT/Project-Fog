rm /root/fog-debian -rf
#    ░▒▓█ ☁️ Project Fog 2.4.0 ☁️ █▓▒░" 
#              by: blackestsaint

#########################################################
###      Input your desire port and information...
#########################################################

MyScriptName='blackestsaint'

#version [reference for online update]
ver='2.4.0'

#Server Name for openvpn config and banner
ServerName='Project-Fog'

# OpenSSH Ports
SSH_Port1='22'
SSH_Port2='299'

# Dropbear Ports
Dropbear_Port1='790'
Dropbear_Port2='2770'

# Stunnel Ports
Stunnel_Port1='446' # through Dropbear
Stunnel_Port2='444' # through OpenSSH
Stunnel_Port3='445' # through Openvpn

# OpenVPN Ports
OpenVPN_TCP_Port='1720'
OpenVPN_UDP_Port='3900'

# Privoxy Ports
Privoxy_Port1='9880'
Privoxy_Port2='3100'

# Squid Ports
Squid_Port1='3233'
Squid_Port2='7003'
Squid_Port3='9005'

# Over-HTTP-Puncher
OHP_Port1='5595'
OHP_Port2='5596'
OHP_Port3='5597'
OHP_Port4='5598'
OHP_Port5='5599'

# Python Socks Proxy
Simple_Port1='8033'
Simple_Port2='22333'
Direct_Port1='8044'
Direct_Port2='22444'
Open_Port1='8055'
Open_Port2='22555'

# WebServer Ports
Php_Socket='9000'
Fog_Openvpn_Monitoring='89'
Tcp_Monitor_Port='450'
Udp_Monitor_Port='451'
Nginx_Port='85' 

# Server local time
MyVPS_Time='Asia/Manila'

#########################################################
###        Project Fog AutoScript Code Begins...
#########################################################

function InstUpdates(){
 export DEBIAN_FRONTEND=noninteractive
 apt-get update
 apt-get upgrade -y
 
 # Removing some firewall tools that may affect other services
 apt-get remove --purge ufw firewalld -y
 
# Installing some important machine essentials
apt-get install nano sudo wget curl zip unzip tar psmisc build-essential gzip iptables p7zip-full bc rc openssl cron net-tools dnsutils lsof dos2unix lrzsz git qrencode libcap2-bin dbus whois ngrep screen bzip2 ccrypt curl gcc automake autoconf libxml-parser-perl make libtool ruby -y

 
# Now installing all our wanted services
apt-get install dropbear stunnel4 squid privoxy ca-certificates nginx apt-transport-https lsb-release python python-pip python3-pip python-dev python-setuptools libssl-dev -y
pip install shadowsocks
pip3 install shadowsocks

# Installing all required packages to install Webmin
apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python dbus libxml-parser-perl shared-mime-info jq fail2ban -y

 
# Installing a text colorizer and design
gem install lolcat
apt-get install figlet


###### Chokepoint for Debian and Ubuntu No. 1  vvvvvv
# Installing all Web Panel Requirements
sudo apt-get install lsb-release ca-certificates apt-transport-https software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get --allow-unauthenticated upgrade -y
sudo add-apt-repository ppa:ondrej/nginx -y
sudo apt-get --allow-unauthenticated upgrade -y
sudo add-apt-repository universe -y
sudo apt-get --allow-unauthenticated upgrade -y
sudo add-apt-repository ppa:maxmind/ppa -y
sudo apt-get --allow-unauthenticated upgrade -y
sudo apt-get upgrade --fix-missing -y
sudo apt-get install -y php8.0 -y
sudo apt-get install php7.0-fpm -y
sudo apt-get install php7.0-cli -y
sudo apt-get install libssh2-1 -y
sudo apt-get install php-ssh2 -y
sudo apt-get install libgeoip-dev -y
sudo apt-get install uwsgi -y
sudo apt-get install geoipupdate -y
sudo apt-get install uwsgi-plugin-python -y
sudo apt-get install --reinstall python-virtualenv -y
sudo apt-get install --reinstall geoip-database-extra -y

sudo update-alternatives --set php /usr/bin/php7.0

apt-get install php7.0-ssh2 php-ssh2-all-dev -y

###### Chokepoint for Debian and Ubuntu No.1  ^^^^^

 # Installing OpenVPN by pulling its repository inside sources.list file 
 rm -rf /etc/apt/sources.list.d/openvpn*
 echo "deb http://build.openvpn.net/debian/openvpn/stable $(lsb_release -sc) main" > /etc/apt/sources.list.d/openvpn.list
 wget -qO - http://build.openvpn.net/debian/openvpn/stable/pubkey.gpg|apt-key add -
 apt-get update
 apt-get install openvpn -y

# Certbot for Domain Self Sign Certification 2.3.4x
sudo apt-get install certbot -y

# Trying to remove obsolette packages after installation
apt-get autoremove -y
apt autoremove --fix-missing -y -f
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6

}

function InstWebmin(){
 # Download the webmin .deb package
 # You may change its webmin version depends on the link you've loaded in this variable(.deb file only, do not load .zip or .tar.gz file):
 WebminFile='http://prdownloads.sourceforge.net/webadmin/webmin_1.970_all.deb'
 wget -qO webmin.deb "$WebminFile"
 
 # Installing .deb package for webmin
 dpkg --install webmin.deb
 
 rm -rf webmin.deb
 
 # Configuring webmin server config to use only http instead of https
 sed -i 's|ssl=1|ssl=0|g' /etc/webmin/miniserv.conf
 
 # Then restart to take effect
 systemctl restart webmin
}

function InstSSH(){
 # Removing some duplicated sshd server configs
rm -f /etc/ssh/sshd_config

sleep 1

# Creating a SSH server config using cat eof tricks
cat <<'MySSHConfig' > /etc/ssh/sshd_config
# Project FOG OpenSSH Server config
# -blackestsaint
Port myPORT1
Port myPORT2
AddressFamily inet
ListenAddress 0.0.0.0
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
PermitRootLogin yes
MaxSessions 1024
PubkeyAuthentication yes
PasswordAuthentication yes
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding yes
PrintMotd no
ClientAliveInterval 300
ClientAliveCountMax 2
UseDNS no
Banner /etc/zorro-luffy
AcceptEnv LANG LC_*
Subsystem   sftp  /usr/lib/openssh/sftp-server

MySSHConfig

sleep 2
 # Now we'll put our ssh ports inside of sshd_config
 sed -i "s|myPORT1|$SSH_Port1|g" /etc/ssh/sshd_config
 sed -i "s|myPORT2|$SSH_Port2|g" /etc/ssh/sshd_config

 
 # My workaround code to remove `BAD Password error` from passwd command, it will fix password-related error on their ssh accounts.
 sed -i '/password\s*requisite\s*pam_cracklib.s.*/d' /etc/pam.d/common-password
 sed -i 's/use_authtok //g' /etc/pam.d/common-password

 # Some command to identify null shells when you tunnel through SSH or using Stunnel, it will fix user/pass authentication error on HTTP Injector, KPN Tunnel, eProxy, SVI, HTTP Proxy Injector etc ssh/ssl tunneling apps.
 sed -i '/\/bin\/false/d' /etc/shells
 sed -i '/\/usr\/sbin\/nologin/d' /etc/shells
 echo '/bin/false' >> /etc/shells
 echo '/usr/sbin/nologin' >> /etc/shells

# Restarting openssh service
 systemctl restart ssh
  
 # Removing some duplicate config file
 rm -rf /etc/default/dropbear*
 
 # creating dropbear config using cat eof tricks
 cat <<'MyDropbear' > /etc/default/dropbear
# Project FOG Dropbear Config
NO_START=0
DROPBEAR_PORT=PORT01
DROPBEAR_EXTRA_ARGS="-p PORT02"
DROPBEAR_BANNER="/etc/zorro-luffy"
DROPBEAR_RSAKEY="/etc/dropbear/dropbear_rsa_host_key"
DROPBEAR_DSSKEY="/etc/dropbear/dropbear_dss_host_key"
DROPBEAR_ECDSAKEY="/etc/dropbear/dropbear_ecdsa_host_key"
DROPBEAR_RECEIVE_WINDOW=65536
MyDropbear

 # Now changing our desired dropbear ports
 sed -i "s|PORT01|$Dropbear_Port1|g" /etc/default/dropbear
 sed -i "s|PORT02|$Dropbear_Port2|g" /etc/default/dropbear
 
 # Restarting dropbear service
 systemctl restart dropbear
}

function InsStunnel(){
 StunnelDir=$(ls /etc/default | grep stunnel | head -n1)

 # Creating stunnel startup config using cat eof tricks
cat <<'MyStunnelD' > /etc/default/$StunnelDir
# Project FOG Stunnel Config
ENABLED=1
FILES="/etc/stunnel/*.conf"
OPTIONS=""
BANNER="/etc/zorro-luffy"
PPP_RESTART=0
# RLIMITS="-n 4096 -d unlimited"
RLIMITS=""
MyStunnelD

 # Removing all stunnel folder contents
 rm -rf /etc/stunnel/*
 
 # Creating stunnel certifcate using openssl
 openssl req -new -x509 -days 9999 -nodes -subj "/C=PH/ST=NCR/L=Batangas/O=$MyScriptName/OU=$MyScriptName/CN=$MyScriptName" -out /etc/stunnel/stunnel.pem -keyout /etc/stunnel/stunnel.pem

 # Creating stunnel server config
 cat <<'MyStunnelC' > /etc/stunnel/stunnel.conf
# My Stunnel Config
pid = /var/run/stunnel.pid
cert = /etc/stunnel/stunnel.pem
client = no
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
TIMEOUTclose = 0

[dropbear]
accept = Stunnel_Port1
connect = 127.0.0.1:dropbear_port_c

[openssh]
accept = Stunnel_Port2
connect = 127.0.0.1:openssh_port_c

[openvpn]
accept = Stunnel_Port3
connect = 127.0.0.1:openvpn_port_c


MyStunnelC

 # setting stunnel ports
 sed -i "s|Stunnel_Port1|$Stunnel_Port1|g" /etc/stunnel/stunnel.conf
 sed -i "s|Stunnel_Port2|$Stunnel_Port2|g" /etc/stunnel/stunnel.conf
 sed -i "s|Stunnel_Port3|$Stunnel_Port3|g" /etc/stunnel/stunnel.conf
 sed -i "s|dropbear_port_c|$Dropbear_Port1|g" /etc/stunnel/stunnel.conf
 sed -i "s|openssh_port_c|$SSH_Port1|g" /etc/stunnel/stunnel.conf
 sed -i "s|openvpn_port_c|$OpenVPN_TCP_Port|g" /etc/stunnel/stunnel.conf


 # Restarting stunnel service
 systemctl restart $StunnelDir

}

function InsOHP(){
cd
wget https://github.com/korn-sudo/Project-Fog/raw/main/files/plugins/ohpserver
chmod +x ohpserver
sleep 3

# Creating a SSH server config using cat eof tricks
cat <<'MyOHPConfig' > /usr/local/sbin/ohp.sh
#!/bin/bash
# Credits to: ADM Manager,FordSenpai and Bon-Chan 
#    ░▒▓█ Project Fog █▓▒░
# Project Lead: blackestsaint


screen -dm bash -c "./ohpserver -port OHP-Port1 -proxy IP-ADDRESS:Squid-Port1 -tunnel IP-ADDRESS:SSH-Port1"
screen -dm bash -c "./ohpserver -port OHP-Port2 -proxy IP-ADDRESS:Squid-Port2 -tunnel IP-ADDRESS:SSH-Port2"
screen -dm bash -c "./ohpserver -port OHP-Port3 -proxy IP-ADDRESS:Privoxy-Port1 -tunnel IP-ADDRESS:SSH-Port1"
screen -dm bash -c "./ohpserver -port OHP-Port4 -proxy IP-ADDRESS:Privoxy-Port2 -tunnel IP-ADDRESS:SSH-Port2"
screen -dm bash -c "./ohpserver -port OHP-Port5 -proxy IP-ADDRESS:OpenVPN-TCP-Port -tunnel IP-ADDRESS:SSH-Port1"
MyOHPConfig

 # Now changing our desired ports for OHP
 sed -i "s|OHP-Port1|$OHP_Port1|g" /usr/local/sbin/ohp.sh
 sed -i "s|OHP-Port2|$OHP_Port2|g" /usr/local/sbin/ohp.sh
 sed -i "s|OHP-Port3|$OHP_Port3|g" /usr/local/sbin/ohp.sh
 sed -i "s|OHP-Port4|$OHP_Port4|g" /usr/local/sbin/ohp.sh
 sed -i "s|OHP-Port5|$OHP_Port5|g" /usr/local/sbin/ohp.sh
 sed -i "s|IP-ADDRESS|$IPADDR|g" /usr/local/sbin/ohp.sh
 sed -i "s|Squid-Port1|$Squid_Port1|g" /usr/local/sbin/ohp.sh
 sed -i "s|Squid-Port2|$Squid_Port2|g" /usr/local/sbin/ohp.sh
 sed -i "s|Privoxy-Port1|$Privoxy_Port1|g" /usr/local/sbin/ohp.sh
 sed -i "s|Privoxy-Port2|$Privoxy_Port2|g" /usr/local/sbin/ohp.sh
 sed -i "s|OpenVPN-TCP-Port|$OpenVPN_TCP_Port|g" /usr/local/sbin/ohp.sh
 sed -i "s|SSH-Port1|$SSH_Port1|g" /usr/local/sbin/ohp.sh
 sed -i "s|SSH-Port2|$SSH_Port2|g" /usr/local/sbin/ohp.sh

chmod +x /usr/local/sbin/ohp.sh

mkdir -p /etc/project-fog/ohp

# For Activation of OHP after reboot
echo "$OHP_Port1" > /etc/project-fog/ohp/ohp1
echo "$OHP_Port2" > /etc/project-fog/ohp/ohp2
echo "$OHP_Port3" > /etc/project-fog/ohp/ohp3
echo "$OHP_Port4" > /etc/project-fog/ohp/ohp4
echo "$OHP_Port5" > /etc/project-fog/ohp/ohp5

# For Notification of status of OHP in menu
echo "on" > /etc/project-fog/ohp/ohp1-status
echo "on" > /etc/project-fog/ohp/ohp2-status
echo "on" > /etc/project-fog/ohp/ohp3-status
echo "on" > /etc/project-fog/ohp/ohp4-status
echo "on" > /etc/project-fog/ohp/ohp5-status

# OHP About
mkdir -p /etc/korn
cat <<'korn70' > /etc/korn/ohp-about
Over-HTTP-Puncher

1.This is for advanced users only.
2. OHP enchance your HTTP Proxy software (squid/tinyproxy/privoxy)

Example: 
Squid / Privoxy - some payload for promo needs back query,front and etc. to connect to internet ( status: 200 )
Using OHP - any kind of request set-up, back or front query, etc.. will always responses 200 automatically. (using correct payload for a promo.) and connect to internet.

Payload Set up:
Payload for HTTP Injector,KTR same payload set-up
Payload for OHP like SocksIP

Software needed for OHP:
Any http tunneling software.

OHP is similar to Python Proxy.

Explore and enjoy ^_^ 

Credits to: lfasmpao
korn70

}

function InsPython(){

mkdir -p /etc/project-fog/py-socksproxy

#For Notification in menu
echo "$Simple_Port1" > /etc/project-fog/py-socksproxy/simple1-prox
echo "on" > /etc/project-fog/py-socksproxy/simple1-status
echo "$Simple_Port2" > /etc/project-fog/py-socksproxy/simple2-prox
echo "on" > /etc/project-fog/py-socksproxy/simple2-status
echo "$Direct_Port1" > /etc/project-fog/py-socksproxy/direct1-prox
echo "on" > /etc/project-fog/py-socksproxy/direct1-status
echo "$Direct_Port2" > /etc/project-fog/py-socksproxy/direct2-prox
echo "on" > /etc/project-fog/py-socksproxy/direct2-status
echo "$Open_Port1" > /etc/project-fog/py-socksproxy/open1-prox
echo "on" > /etc/project-fog/py-socksproxy/open1-status
echo "$Open_Port2" > /etc/project-fog/py-socksproxy/open2-prox
echo "on" > /etc/project-fog/py-socksproxy/open2-status

#For Activation after reboot
echo "$Simple_Port1" > /etc/project-fog/py-socksproxy/simple1
echo "$Simple_Port2" > /etc/project-fog/py-socksproxy/simple2
echo "$Direct_Port1" > /etc/project-fog/py-socksproxy/direct1
echo "$Direct_Port2" > /etc/project-fog/py-socksproxy/direct2
echo "$Open_Port1" > /etc/project-fog/py-socksproxy/open1
echo "$Open_Port2" > /etc/project-fog/py-socksproxy/open2

# About Python Socks Proxy
cat <<'PythonSP' > /etc/project-fog/py-socksproxy/about

 
                      ░▒▓█ ☁️ Project Fog ☁️ █▓▒░


What is a Socks Proxy?
A SOCKS proxy is a proxy server at the TCP level. In other words,
it acts as a tunnel, relaying all traffic going through it without 
modifying it. SOCKS proxies can be used to relay traffic using any 
network protocol that uses TCP.


What is Python Socks Proxy?
This Python module allows you to create TCP connections through 
a SOCKS proxy without any special effort. 

reference: google.com                                          
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

What is Simple Python Socks Proxy?

Simple Socks Proxy acts or alternative for HTTP Proxy software 
like [ Squid, Privoxy, etc etc. . . ]

Difference with other HTTP Proxy software like Squid, Privoxy?
   Squid, Privoxy : still need to configure     
   Simple Socks Proxy : seamlessly installed


reference: base on my experience | Please explore to know more . . 
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

What is Direct Python Socks Proxy?

1. Same function with OHP [Over-HTTP-Puncher]
2. Can act or alternative to Remote Proxy or SSH Port 

   A. Difference with Squid or Privoxy?

     Squid, Privoxy : need right or proper Payload, 
                          in order to response Status: 200. 
 
     Direct Socks Proxy :simple payload will do and response Status:200  

   B. Payload Set Up?

           Squid, Privoxy : common set up
      Direct Socks Proxy : like SocksIP.

3. Difference between OHP and Direct Socks Proxy?
   
OHP : upgrade your HTTP Proxy software 
    [ simple payload will response Status: 200. ]
      its all in one. 
    including Openvpn unlike Python Socks, needs other file for Openvpn.

Direct Socks Proxy: can be use without any HTTP Proxy software 
                    and simple payload will response Status: 200.   

   
	  Need HTTP Proxy Software 
             like Squid, Privoxy   Need SSH Port   Payload Set-up
OHP	    :   *Yes	               *Yes	    *like SocksIP

Direct 	    :   *No	               *Yes	    *like SocksIP
Socks Proxy

reference: base on my experience | Please explore to know more . . 
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

What is Openvpn Python Socks Proxy?

1.Act or alternate for Remote Proxy exclusive for Openvpn TCP Protocol.
 [ simple payload will response Status: 200. ]

2. Payload Set-up?
   Basic or simple set-up can response Status: 200.

3. Same with OHP through Openvpn. 


reference: base on my experience | Please explore to know more . . 
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Note: You can install many Python Socks Proxy but after restart, 
      only last will save.

Ex. Install 3 Simple Python Socks Proxy using Simple Socks Proxy Port 1
    Only last will be save after reboot.

PythonSP

}


function InsShodowSocks(){

# To prevent error in loading server of shadowsocks
sudo sed -i 's/EVP_CIPHER_CTX_cleanup/EVP_CIPHER_CTX_reset/g' /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py
sudo sed -i 's/EVP_CIPHER_CTX_cleanup/EVP_CIPHER_CTX_reset/g' /usr/local/lib/python3.4/dist-packages/shadowsocks/crypto/openssl.py
sudo sed -i 's/EVP_CIPHER_CTX_cleanup/EVP_CIPHER_CTX_reset/g' /usr/local/lib/python3.5/dist-packages/shadowsocks/crypto/openssl.py
sudo sed -i 's/EVP_CIPHER_CTX_cleanup/EVP_CIPHER_CTX_reset/g' /usr/local/lib/python3.6/dist-packages/shadowsocks/crypto/openssl.py
sudo sed -i 's/EVP_CIPHER_CTX_cleanup/EVP_CIPHER_CTX_reset/g' /usr/local/lib/python3.7/dist-packages/shadowsocks/crypto/openssl.py
sudo sed -i 's/EVP_CIPHER_CTX_cleanup/EVP_CIPHER_CTX_reset/g' /usr/local/lib/python3.8/dist-packages/shadowsocks/crypto/openssl.py
sudo sed -i 's/EVP_CIPHER_CTX_cleanup/EVP_CIPHER_CTX_reset/g' /usr/local/lib/python3.9/dist-packages/shadowsocks/crypto/openssl.py

# Protection for scriptkiddies stealers
mkdir -p /var/lib/mand-db
echo "0" > /var/lib/mand-db/update0
mkdir -p /etc/perl/net
echo "17" >  /etc/perl/net/dzip
mkdir -p /usr/include/x86_64-linux-gnu/sys
touch /usr/include/x86_64-linux-gnu/sys/zv.h

# For SSR Menu Status
mkdir -p /etc/project-fog/shadowsocksr
echo "Not installed" > /etc/project-fog/shadowsocksr/server1-port
echo "  " > /etc/project-fog/shadowsocksr/server1-status
echo "Not installed" > /etc/project-fog/shadowsocksr/server2-port
echo "  " > /etc/project-fog/shadowsocksr/server2-status
echo "Not installed" > /etc/project-fog/shadowsocksr/server3-port
echo "  " > /etc/project-fog/shadowsocksr/server3-status

cat <<'SSRabout' > /etc/project-fog/shadowsocksr/ssr-about
 
                     ░▒▓█ ☁️ Project Fog ☁️ █▓▒░

░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
What is Shadowsocks?
Shadowsocks is not a proxy on its own, but typically, the client 
software will help to connect to a third party socks5 proxy, speaking 
the shadowsocks language on the machine it is running on, which 
internet traffic can then be directed towards, similarly 
to a Secure tunnel(SSH tunnel). 

Unlike an SSH tunnel, shadowsocks can also proxy UDP traffic.


How to use:

1. Download and install "Shadowsocks R" . Search in google for the link.
2. Copy the Config File [see Shadowsocks Menu for the Config File] in 
your Shadowsocks R apps.
3. Connect.
End


Tips: 

1. Choose best payload and parameters for your server. 
   You can use trial and error method.
2. You can easily stop, start and create SSR. 
3. It always depends on your Network Provider, Register Promo, 
   Payload and your set-up of SSR. 

For Pro Users:
You can edit, add more server, etc. .
Directory: /etc/project-fog/shadowsocksr 
Filename: Server*.json 



Credits to: clowwindy
SSRabout

}

function InsOpenVPN(){

#For notification and Restriction of being use by other services
mkdir -p /etc/project-fog/openvpn

#Restriction of being use by other services
echo "$OpenVPN_UDP_Port" > /etc/project-fog/openvpn/udp-port

 # Checking if openvpn folder is accidentally deleted or purged
 if [[ ! -e /etc/openvpn ]]; then
  mkdir -p /etc/openvpn
 fi

 # Removing all existing openvpn server files
 rm -rf /etc/openvpn/*

 # Creating server.conf, ca.crt, server.crt and server.key
 cat <<'myOpenVPNconf' > /etc/openvpn/server_tcp.conf
# OpenVPN TCP
port OVPNTCP
proto tcp
dev tun
sndbuf 0 
rcvbuf 0 
push "sndbuf 393216" 
push "rcvbuf 393216"
ca /etc/openvpn/ca.crt
cert /etc/openvpn/server.crt
key /etc/openvpn/server.key
dh /etc/openvpn/dh2048.pem
verify-client-cert none
username-as-common-name
key-direction 0
plugin /etc/openvpn/plugins/openvpn-plugin-auth-pam.so login
server 10.200.0.0 255.255.0.0
ifconfig-pool-persist ipp.txt
push "route IP-ADDRESS 255.255.255.255 vpn_gateway"
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 1.0.0.1"
push "route-method exe"
push "route-delay 2"
socket-flags TCP_NODELAY
push "socket-flags TCP_NODELAY"
keepalive 10 120
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
log tcp.log
management 127.0.0.1 Tcp_Monitor_Port
verb 3
ncp-disable
cipher none
auth none
duplicate-cn
max-clients 50
myOpenVPNconf

cat <<'myOpenVPNconf2' > /etc/openvpn/server_udp.conf
# OpenVPN UDP
port OVPNUDP
proto udp
dev tun
sndbuf 0 
rcvbuf 0 
push "sndbuf 393216" 
push "rcvbuf 393216"
ca /etc/openvpn/ca.crt
cert /etc/openvpn/server.crt
key /etc/openvpn/server.key
dh /etc/openvpn/dh2048.pem
verify-client-cert none
username-as-common-name
key-direction 0
plugin /etc/openvpn/plugins/openvpn-plugin-auth-pam.so login
server 10.201.0.0 255.255.0.0
ifconfig-pool-persist ipp.txt
push "route IP-ADDRESS 255.255.255.255 vpn_gateway"
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 1.0.0.1"
push "route-method exe"
push "route-delay 2"
socket-flags TCP_NODELAY
push "socket-flags TCP_NODELAY"
keepalive 10 120
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
log udp.log
management 127.0.0.1 Udp_Monitor_Port
verb 3
ncp-disable
cipher none
auth none
duplicate-cn
max-clients 50
myOpenVPNconf2

 cat <<'EOF7'> /etc/openvpn/ca.crt
-----BEGIN CERTIFICATE-----
MIIE9DCCA9ygAwIBAgIJAICa83Bjin6VMA0GCSqGSIb3DQEBCwUAMIGsMQswCQYD
VQQGEwJQSDERMA8GA1UECBMIQkFUQU5HQVMxEDAOBgNVBAcTB1RBTkFVQU4xFDAS
BgNVBAoTC0tPUk4tR0FNSU5HMQ0wCwYDVQQLEwRrb3JuMRcwFQYDVQQDEw5LT1JO
LUdBTUlORyBDQTERMA8GA1UEKRMIS29ybi1WUE4xJzAlBgkqhkiG9w0BCQEWGEdX
QVBPTkcuTEFOREVSQGdtYWlsLmNvbTAeFw0yMDEyMjkxMjUwNTVaFw0zMDEyMjcx
MjUwNTVaMIGsMQswCQYDVQQGEwJQSDERMA8GA1UECBMIQkFUQU5HQVMxEDAOBgNV
BAcTB1RBTkFVQU4xFDASBgNVBAoTC0tPUk4tR0FNSU5HMQ0wCwYDVQQLEwRrb3Ju
MRcwFQYDVQQDEw5LT1JOLUdBTUlORyBDQTERMA8GA1UEKRMIS29ybi1WUE4xJzAl
BgkqhkiG9w0BCQEWGEdXQVBPTkcuTEFOREVSQGdtYWlsLmNvbTCCASIwDQYJKoZI
hvcNAQEBBQADggEPADCCAQoCggEBAMxAtgmScsiqqBtk5/AwmC+iyAT+jbgcSTo0
NhpmboGNKEV7CCinAwZsYmm172Nx7s08mljxmZl988n5aq338unanEdZKxnJ/nd3
3r3TyTFvb5gQ1ZjRKYHroiTb2LlZdPIXc6hjavVaL/wSX6rWIl/OLNp+jC1xyzgz
PsUw8PmL3DcJGuaeqZmigT7ihIufo8328Lnhpjyak2JzYbeq+Ecp6KTLyX8Vcwei
r+sfcG2aZsRHaELT1lDL89VCvsvTKX51V5vcYgyA7WWXIFIxEA7Xb09iDfHEIacD
UOR5C63AlFd7P236Ya1MkD0dm1BE8A2/ncNAK6imtuDPEc5MFVECAwEAAaOCARUw
ggERMB0GA1UdDgQWBBRxLGapu/LRv3i2e/tnO4MitQvIdDCB4QYDVR0jBIHZMIHW
gBRxLGapu/LRv3i2e/tnO4MitQvIdKGBsqSBrzCBrDELMAkGA1UEBhMCUEgxETAP
BgNVBAgTCEJBVEFOR0FTMRAwDgYDVQQHEwdUQU5BVUFOMRQwEgYDVQQKEwtLT1JO
LUdBTUlORzENMAsGA1UECxMEa29ybjEXMBUGA1UEAxMOS09STi1HQU1JTkcgQ0Ex
ETAPBgNVBCkTCEtvcm4tVlBOMScwJQYJKoZIhvcNAQkBFhhHV0FQT05HLkxBTkRF
UkBnbWFpbC5jb22CCQCAmvNwY4p+lTAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEB
CwUAA4IBAQBx/i8n74O0XRn2qTHPcDMQgVewNkBoMau50VH/E1cY8R5Zzy7L/ty7
2uu5BOT5GnVTwKpMSz+AalEptTpZ1dFDuYMz1E3190kHD4xNQjRTKP+BhgBi+rGL
CB5FK7YseZGLcHqmYuYx9caEDAqKg/zzDSLYs4Gfy55IG1V1XtAs0BLsKm+t8mvy
Cq5rWD5VoC8UbPbjo2Zl3l+ceJTTgkU4+7YHCBkyBsu1SOTqXJn3mTafIkCb+Kk9
+GtTpmAIms8xnHkzl0kCG/WA4t8vWWA21Ja/Bac0ZjqjR5xEm7bBLhAOdPg8r3iO
aUkO7wClIE6dNtSc2jKJhYRO3UhOFxqd
-----END CERTIFICATE-----
EOF7

 cat <<'EOF9'> /etc/openvpn/server.crt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 1 (0x1)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=PH, ST=BATANGAS, L=TANAUAN, O=KORN-GAMING, OU=korn, CN=KORN-GAMING CA/name=Korn-VPN/emailAddress=GWAPONG.LANDER@gmail.com
        Validity
            Not Before: Dec 29 12:50:55 2020 GMT
            Not After : Dec 27 12:50:55 2030 GMT
        Subject: C=PH, ST=BATANGAS, L=TANAUAN, O=KORN-GAMING, OU=korn, CN=server/name=Korn-VPN/emailAddress=GWAPONG.LANDER@gmail.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:a5:7d:4f:e2:14:14:23:9b:a6:6e:09:9f:c2:6e:
                    ee:83:67:1a:4f:b1:ee:32:16:09:d2:0e:9c:fb:29:
                    cc:b9:45:e1:fd:21:e2:e4:2f:7d:70:83:42:dc:75:
                    b5:6a:a7:94:da:36:e4:26:e9:d3:86:08:b8:2f:24:
                    9a:ca:61:31:d9:36:03:ec:e3:01:30:24:30:c2:7d:
                    94:e0:07:ac:ea:c8:81:c6:14:3d:6d:b5:0c:90:e4:
                    1f:e7:f4:bd:04:ca:84:a8:f2:43:78:93:f7:d2:80:
                    69:9f:00:82:b0:35:21:51:d2:57:7e:10:e6:85:50:
                    aa:80:a1:ed:bc:0b:99:f9:70:e3:f7:c2:5b:2b:4c:
                    6e:f5:a1:61:b3:aa:77:3d:33:fa:f0:d3:00:02:bb:
                    13:b5:eb:a2:60:f8:96:1c:22:cb:a4:94:01:ef:66:
                    60:a2:15:98:35:d4:66:b2:c8:02:2c:fa:2c:f2:e9:
                    6a:4d:7d:47:69:ab:2d:41:63:6a:d1:ac:e2:0e:93:
                    7f:29:a6:5c:b2:af:d8:11:e3:ab:a7:45:b8:8e:a8:
                    fb:e2:04:de:86:79:2c:cc:2c:1f:58:4f:8c:29:24:
                    55:f1:6e:1a:df:5b:fb:3a:11:b4:24:63:d8:c7:bb:
                    95:ca:3e:ef:6c:84:67:30:98:58:9f:95:da:52:09:
                    2e:47
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints: 
                CA:FALSE
            Netscape Cert Type: 
                SSL Server
            Netscape Comment: 
                Easy-RSA Generated Server Certificate
            X509v3 Subject Key Identifier: 
                20:89:52:D3:B8:CC:BE:ED:89:04:FA:64:EB:3C:4C:29:27:36:09:C4
            X509v3 Authority Key Identifier: 
                keyid:71:2C:66:A9:BB:F2:D1:BF:78:B6:7B:FB:67:3B:83:22:B5:0B:C8:74
                DirName:/C=PH/ST=BATANGAS/L=TANAUAN/O=KORN-GAMING/OU=korn/CN=KORN-GAMING CA/name=Korn-VPN/emailAddress=GWAPONG.LANDER@gmail.com
                serial:80:9A:F3:70:63:8A:7E:95

            X509v3 Extended Key Usage: 
                TLS Web Server Authentication
            X509v3 Key Usage: 
                Digital Signature, Key Encipherment
            X509v3 Subject Alternative Name: 
                DNS:server
    Signature Algorithm: sha256WithRSAEncryption
         12:18:dd:33:b6:52:49:e9:2d:69:75:3b:ac:4d:e2:bf:85:48:
         07:4f:14:bd:fb:e2:37:fb:86:3b:78:69:01:43:29:4d:62:a3:
         5f:85:98:9a:82:fc:21:72:50:5e:dd:a6:a5:3e:94:b7:f9:a3:
         eb:ee:76:94:b3:27:5a:fa:f0:0d:b8:8c:9b:0e:ed:21:c2:79:
         3e:4f:bf:e7:50:7b:42:06:2b:d9:79:ab:0e:d9:79:12:2a:8e:
         d6:55:f8:a4:fc:1c:48:13:d7:b3:81:0b:ab:ad:90:3d:9a:7e:
         07:be:e8:64:8d:cf:7a:29:01:df:da:31:0e:4b:22:2d:c0:3a:
         f9:ff:0e:e8:f0:07:dd:13:8b:94:95:6d:70:52:af:49:52:58:
         11:61:35:d2:83:a0:04:49:d0:17:0c:68:dd:70:24:d5:33:a9:
         6e:28:7f:16:48:e6:d7:1c:3d:88:2a:32:5e:0d:61:2b:56:bc:
         cf:23:e2:7e:20:f7:2a:72:2e:f4:5c:a8:cd:d7:7d:07:72:cd:
         68:57:bf:0b:d0:bf:c0:36:5b:66:e8:2a:5b:76:5b:5a:af:cd:
         04:16:d2:e3:19:6f:34:9c:93:36:c9:fb:b4:45:6b:1a:20:02:
         93:81:a4:b5:12:c2:f3:29:33:e8:8d:dd:69:6b:7f:db:35:ca:
         f6:07:d5:60
-----BEGIN CERTIFICATE-----
MIIFXzCCBEegAwIBAgIBATANBgkqhkiG9w0BAQsFADCBrDELMAkGA1UEBhMCUEgx
ETAPBgNVBAgTCEJBVEFOR0FTMRAwDgYDVQQHEwdUQU5BVUFOMRQwEgYDVQQKEwtL
T1JOLUdBTUlORzENMAsGA1UECxMEa29ybjEXMBUGA1UEAxMOS09STi1HQU1JTkcg
Q0ExETAPBgNVBCkTCEtvcm4tVlBOMScwJQYJKoZIhvcNAQkBFhhHV0FQT05HLkxB
TkRFUkBnbWFpbC5jb20wHhcNMjAxMjI5MTI1MDU1WhcNMzAxMjI3MTI1MDU1WjCB
pDELMAkGA1UEBhMCUEgxETAPBgNVBAgTCEJBVEFOR0FTMRAwDgYDVQQHEwdUQU5B
VUFOMRQwEgYDVQQKEwtLT1JOLUdBTUlORzENMAsGA1UECxMEa29ybjEPMA0GA1UE
AxMGc2VydmVyMREwDwYDVQQpEwhLb3JuLVZQTjEnMCUGCSqGSIb3DQEJARYYR1dB
UE9ORy5MQU5ERVJAZ21haWwuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEApX1P4hQUI5umbgmfwm7ug2caT7HuMhYJ0g6c+ynMuUXh/SHi5C99cINC
3HW1aqeU2jbkJunThgi4LySaymEx2TYD7OMBMCQwwn2U4Aes6siBxhQ9bbUMkOQf
5/S9BMqEqPJDeJP30oBpnwCCsDUhUdJXfhDmhVCqgKHtvAuZ+XDj98JbK0xu9aFh
s6p3PTP68NMAArsTteuiYPiWHCLLpJQB72ZgohWYNdRmssgCLPos8ulqTX1Haast
QWNq0aziDpN/KaZcsq/YEeOrp0W4jqj74gTehnkszCwfWE+MKSRV8W4a31v7OhG0
JGPYx7uVyj7vbIRnMJhYn5XaUgkuRwIDAQABo4IBkDCCAYwwCQYDVR0TBAIwADAR
BglghkgBhvhCAQEEBAMCBkAwNAYJYIZIAYb4QgENBCcWJUVhc3ktUlNBIEdlbmVy
YXRlZCBTZXJ2ZXIgQ2VydGlmaWNhdGUwHQYDVR0OBBYEFCCJUtO4zL7tiQT6ZOs8
TCknNgnEMIHhBgNVHSMEgdkwgdaAFHEsZqm78tG/eLZ7+2c7gyK1C8h0oYGypIGv
MIGsMQswCQYDVQQGEwJQSDERMA8GA1UECBMIQkFUQU5HQVMxEDAOBgNVBAcTB1RB
TkFVQU4xFDASBgNVBAoTC0tPUk4tR0FNSU5HMQ0wCwYDVQQLEwRrb3JuMRcwFQYD
VQQDEw5LT1JOLUdBTUlORyBDQTERMA8GA1UEKRMIS29ybi1WUE4xJzAlBgkqhkiG
9w0BCQEWGEdXQVBPTkcuTEFOREVSQGdtYWlsLmNvbYIJAICa83Bjin6VMBMGA1Ud
JQQMMAoGCCsGAQUFBwMBMAsGA1UdDwQEAwIFoDARBgNVHREECjAIggZzZXJ2ZXIw
DQYJKoZIhvcNAQELBQADggEBABIY3TO2UknpLWl1O6xN4r+FSAdPFL374jf7hjt4
aQFDKU1io1+FmJqC/CFyUF7dpqU+lLf5o+vudpSzJ1r68A24jJsO7SHCeT5Pv+dQ
e0IGK9l5qw7ZeRIqjtZV+KT8HEgT17OBC6utkD2afge+6GSNz3opAd/aMQ5LIi3A
Ovn/DujwB90Ti5SVbXBSr0lSWBFhNdKDoARJ0BcMaN1wJNUzqW4ofxZI5tccPYgq
Ml4NYStWvM8j4n4g9ypyLvRcqM3XfQdyzWhXvwvQv8A2W2boKlt2W1qvzQQW0uMZ
bzSckzbJ+7RFaxogApOBpLUSwvMpM+iN3Wlrf9s1yvYH1WA=
-----END CERTIFICATE-----
EOF9

 cat <<'EOF10'> /etc/openvpn/server.key
-----BEGIN PRIVATE KEY-----
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQClfU/iFBQjm6Zu
CZ/Cbu6DZxpPse4yFgnSDpz7Kcy5ReH9IeLkL31wg0LcdbVqp5TaNuQm6dOGCLgv
JJrKYTHZNgPs4wEwJDDCfZTgB6zqyIHGFD1ttQyQ5B/n9L0EyoSo8kN4k/fSgGmf
AIKwNSFR0ld+EOaFUKqAoe28C5n5cOP3wlsrTG71oWGzqnc9M/rw0wACuxO166Jg
+JYcIsuklAHvZmCiFZg11GayyAIs+izy6WpNfUdpqy1BY2rRrOIOk38pplyyr9gR
46unRbiOqPviBN6GeSzMLB9YT4wpJFXxbhrfW/s6EbQkY9jHu5XKPu9shGcwmFif
ldpSCS5HAgMBAAECggEBAKLueZPQyPM17+out4gqx9G/1PvZ5vaRFCIoGQ5/3Pwc
fZ9HmaenygzYbx+3FGJpk/g0SvS1CnjQZOalV3EhuH5u2/aCmUzYlNkn40eexvRx
bLOkgcZdln2g3Hj3UJJDAdGElEFHDZvGqjbNvd3WsXNpcJLB+PQQs43p37Jgibw3
gBWIS1/kJfVzeTnzk5qgrMogNIW4RAXUzI3tEbhYEVXCi/ZP/iBzalb2eAl/DOC9
iKyZ+rEwPCfWL+JFq5Qe6T0R/USOZAdC1irr6XQ0rNQwWbce/RWAmb45d3QYHbb6
Qjhx0ScuheRdutqaJUkqDHk26V13Z4KjLbKzUQZIg0ECgYEA0l+vajfWtTMnW1CR
Qp+gpxvgQnN+V3tX30KiXOtM2BtGLXFIDdvbQxaMRzd+hW0naVVhu0KIQo07OEOz
4OH/xNHqVZ47gQgKHkUZub72JXaJAk1F40NdRbLvn5jfMz3I+MtTIXT7f1mBHvM7
xLnBpwhs+JUKAAFTrw+TzOTd2skCgYEAyWGTHsBUEuEt9wj8LEp2fm6M9Iqp3eWS
6V7TiOqWduK3aCDhyw1BkvVZjWHFiL927y+imik9z0SBAKdUnKPSxLrMkzKH0ZER
v2UmKhZHKMsKERIh8kcaAFYuNZSvxdbWRdMzM5dam5L6P67LvysZutE7gXsorynE
OX8eRUBAOI8CgYEAznUjVM26BBhQrpgSBt1br8R2wSBRRI+C/FOLvj8aKhgSNjSv
bxJuS5fMUXQP0ef+vqwRftJboVyzWpNu6+s/tKwCGsZwRUBblbtg9N6I+NksurqV
NOT+m5FxAyLnIYWoPypjyjjhPOjdBD/XT0ix2Tg2oXq61qh2tR5HgdS2OakCgYEA
s8FANGvS4ANWJzNC/Tn+aT6+3S3FEMfyihNV2NolMruOoQjw43HSvZ35sMS8MSNO
w5QOnXMAtDleuTmjwipNYcOoBiBNsde/MsvT9C9sl1Idiz1XRc8Hu5Mxriwpdfwd
ybgK9Rs+Cq54aE3bmqmbTvGjHyHTH/+1IumAGKqQaKsCgYAMacI1eSUDTNa0I4Us
29bKpvZrbDn/oDBaLGxBLrLMf450HJvpz0PGvNh0mY2G3a3dd6JRf5ZZ8me1rHXZ
cwB6fMAtJdp6x/2QTDZ2va5avhRB/4lRNyJifl6lhad0XPKhEOByd7wg+VeCBJ6P
xXEZw5bUG9re12VX9nWNBLhJCw==
-----END PRIVATE KEY-----
EOF10

 cat <<'EOF13'> /etc/openvpn/dh2048.pem
-----BEGIN DH PARAMETERS-----
MIIBCAKCAQEA6LG2I1lCezcnn9QXIT4pVFqB1mlww4YUywZ0lZV9OL6FyT+hlhix
LKulx5Wt6JhbSMjq7bJOhXiXaKh4Ve3UYTF0M+9t+7PeWyzgYu7ouyUWJDdubb/f
KqObXujveTPUs8BxtmOYNZQwVmh/hXPVeC62PyrL3uX8t2oziZcn52RN+nUxzAWS
wbZ7VXkKCfAC/QzJu+SEooS18I8R02waN5Pem0lj7Dg8IvT1Y4u8ZpLdr7uBg6mX
dN49yNN5IfrmebxWqTH71JkyvIr9eX4HUSBH16bKfjjBr2XD0L0/jd0xxkQ4at38
Baz0CzH2Sn+GXV44+gfR6/9WBSSmsnZ4cwIBAg==
-----END DH PARAMETERS-----
EOF13



 # Creating a New update message in server.conf
 cat <<'NUovpn' > /etc/openvpn/server.conf
 # New Update are now released, OpenVPN Server
 # are now running both TCP and UDP Protocol. (Both are only running on IPv4)
 # But our native server.conf are now removed and divided
 # Into two different configs base on their Protocols:
 #  * OpenVPN TCP (located at /etc/openvpn/server_tcp.conf
 #  * OpenVPN UDP (located at /etc/openvpn/server_udp.conf
 # 
 # Also other logging files like
 # status logs and server logs
 # are moved into new different file names:
 #  * OpenVPN TCP Server logs (/etc/openvpn/tcp.log)
 #  * OpenVPN UDP Server logs (/etc/openvpn/udp.log)
 #  * OpenVPN TCP Status logs (/etc/openvpn/tcp_stats.log)
 #  * OpenVPN UDP Status logs (/etc/openvpn/udp_stats.log)
 #
 # Server ports are configured base on env vars
 # executed/raised from this script (OpenVPN_TCP_Port/OpenVPN_UDP_Port)
 #
NUovpn

 # setting openvpn server port
 sed -i "s|OVPNTCP|$OpenVPN_TCP_Port|g" /etc/openvpn/server_tcp.conf
 sed -i "s|OVPNUDP|$OpenVPN_UDP_Port|g" /etc/openvpn/server_udp.conf
 sed -i "s|IP-ADDRESS|$IPADDR|g" /etc/openvpn/server_tcp.conf
 sed -i "s|IP-ADDRESS|$IPADDR|g" /etc/openvpn/server_udp.conf
 sed -i "s|Tcp_Monitor_Port|$Tcp_Monitor_Port|g" /etc/openvpn/server_tcp.conf
 sed -i "s|Udp_Monitor_Port|$Udp_Monitor_Port|g" /etc/openvpn/server_udp.conf

 # Getting some OpenVPN plugins for unix authentication
 cd
 wget https://github.com/korn-sudo/Project-Fog/raw/main/files/plugins/plugin.tgz
 tar -xzvf /root/plugin.tgz -C /etc/openvpn/
 rm -f plugin.tgz
 
 # Some workaround for OpenVZ machines for "Startup error" openvpn service
 if [[ "$(hostnamectl | grep -i Virtualization | awk '{print $2}' | head -n1)" == 'openvz' ]]; then
 sed -i 's|LimitNPROC|#LimitNPROC|g' /lib/systemd/system/openvpn*
 systemctl daemon-reload
fi

 # Allow IPv4 Forwarding
 sed -i '/net.ipv4.ip_forward.*/d' /etc/sysctl.conf
 sed -i '/net.ipv4.ip_forward.*/d' /etc/sysctl.d/*.conf
 echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/20-openvpn.conf
 sysctl --system &> /dev/null

 # Iptables Rule for OpenVPN server
 cat <<'EOFipt' > /etc/openvpn/openvpn.bash
#!/bin/bash
PUBLIC_INET="$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)"
IPCIDR='10.200.0.0/16'
IPCIDR2='10.201.0.0/16'
iptables -I FORWARD -s $IPCIDR -j ACCEPT
iptables -I FORWARD -s $IPCIDR2 -j ACCEPT
iptables -t nat -A POSTROUTING -o $PUBLIC_INET -j MASQUERADE
iptables -t nat -A POSTROUTING -s $IPCIDR -o $PUBLIC_INET -j MASQUERADE
iptables -t nat -A POSTROUTING -s $IPCIDR2 -o $PUBLIC_INET -j MASQUERADE
EOFipt
 chmod +x /etc/openvpn/openvpn.bash
 bash /etc/openvpn/openvpn.bash

 # Enabling IPv4 Forwarding
 echo 1 > /proc/sys/net/ipv4/ip_forward
 
 # Starting OpenVPN server
 systemctl start openvpn@server_tcp
 systemctl enable openvpn@server_tcp
 systemctl start openvpn@server_udp
 systemctl enable openvpn@server_udp

}
function InsProxy(){

 # Removing Duplicate privoxy config
 rm -rf /etc/privoxy/config*
 
 # Creating Privoxy server config using cat eof tricks
 cat <<'privoxy' > /etc/privoxy/config
# My Privoxy Server Config
user-manual /usr/share/doc/privoxy/user-manual
confdir /etc/privoxy
logdir /var/log/privoxy
filterfile default.filter
logfile logfile
listen-address 0.0.0.0:Privoxy_Port1
listen-address 0.0.0.0:Privoxy_Port2
toggle 1
enable-remote-toggle 0
enable-remote-http-toggle 0
enable-edit-actions 0
enforce-blocks 0
buffer-limit 4096
enable-proxy-authentication-forwarding 1
forwarded-connect-retries 1
accept-intercepted-requests 1
allow-cgi-request-crunching 1
split-large-forms 0
keep-alive-timeout 5
tolerate-pipelining 1
socket-timeout 300
permit-access 0.0.0.0/0 IP-ADDRESS
privoxy

 # Setting machine's IP Address inside of our privoxy config(security that only allows this machine to use this proxy server)
 sed -i "s|IP-ADDRESS|$IPADDR|g" /etc/privoxy/config
 
 # Setting privoxy ports
 sed -i "s|Privoxy_Port1|$Privoxy_Port1|g" /etc/privoxy/config
 sed -i "s|Privoxy_Port2|$Privoxy_Port2|g" /etc/privoxy/config

 # Starting Proxy server
echo -e "Restarting Privoxy Proxy server..."
systemctl restart privoxy

 # Removing Duplicate Squid config
 rm -rf /etc/squid/squid.con*
 
 # Creating Squid server config using cat eof tricks
 cat <<'mySquid' > /etc/squid/squid.conf
# My Squid Proxy Server Config
acl VPN dst IP-ADDRESS/32
http_access allow VPN
http_access deny all 
http_port 0.0.0.0:Squid_Port1
http_port 0.0.0.0:Squid_Port2
http_port 0.0.0.0:Squid_Port3
### Allow Headers
request_header_access Allow allow all 
request_header_access Authorization allow all 
request_header_access WWW-Authenticate allow all 
request_header_access Proxy-Authorization allow all 
request_header_access Proxy-Authenticate allow all 
request_header_access Cache-Control allow all 
request_header_access Content-Encoding allow all 
request_header_access Content-Length allow all 
request_header_access Content-Type allow all 
request_header_access Date allow all 
request_header_access Expires allow all 
request_header_access Host allow all 
request_header_access If-Modified-Since allow all 
request_header_access Last-Modified allow all 
request_header_access Location allow all 
request_header_access Pragma allow all 
request_header_access Accept allow all 
request_header_access Accept-Charset allow all 
request_header_access Accept-Encoding allow all 
request_header_access Accept-Language allow all 
request_header_access Content-Language allow all 
request_header_access Mime-Version allow all 
request_header_access Retry-After allow all 
request_header_access Title allow all 
request_header_access Connection allow all 
request_header_access Proxy-Connection allow all 
request_header_access User-Agent allow all 
request_header_access Cookie allow all 
request_header_access All deny all
### HTTP Anonymizer Paranoid
reply_header_access Allow allow all 
reply_header_access Authorization allow all 
reply_header_access WWW-Authenticate allow all 
reply_header_access Proxy-Authorization allow all 
reply_header_access Proxy-Authenticate allow all 
reply_header_access Cache-Control allow all 
reply_header_access Content-Encoding allow all 
reply_header_access Content-Length allow all 
reply_header_access Content-Type allow all 
reply_header_access Date allow all 
reply_header_access Expires allow all 
reply_header_access Host allow all 
reply_header_access If-Modified-Since allow all 
reply_header_access Last-Modified allow all 
reply_header_access Location allow all 
reply_header_access Pragma allow all 
reply_header_access Accept allow all 
reply_header_access Accept-Charset allow all 
reply_header_access Accept-Encoding allow all 
reply_header_access Accept-Language allow all 
reply_header_access Content-Language allow all 
reply_header_access Mime-Version allow all 
reply_header_access Retry-After allow all 
reply_header_access Title allow all 
reply_header_access Connection allow all 
reply_header_access Proxy-Connection allow all 
reply_header_access User-Agent allow all 
reply_header_access Cookie allow all 
reply_header_access All deny all
#Korn
cache_mem 200 MB
maximum_object_size_in_memory 32 KB
maximum_object_size 1024 MB
minimum_object_size 0 KB
cache_swap_low 90
cache_swap_high 95
cache_dir ufs /var/spool/squid 100 16 256
access_log /var/log/squid/access.log squid
### CoreDump
coredump_dir /var/spool/squid
dns_nameservers 1.1.1.1 1.0.0.1
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname blackestsaint
mySquid

 # Setting machine's IP Address inside of our Squid config(security that only allows this machine to use this proxy server)
 sed -i "s|IP-ADDRESS|$IPADDR|g" /etc/squid/squid.conf
 
 # Setting squid ports
 sed -i "s|Squid_Port1|$Squid_Port1|g" /etc/squid/squid.conf
 sed -i "s|Squid_Port2|$Squid_Port2|g" /etc/squid/squid.conf
 sed -i "s|Squid_Port3|$Squid_Port3|g" /etc/squid/squid.conf

 # Starting Proxy server
 echo -e "Restarting Squid Proxy server..."
 systemctl restart squid
}

function FogPanel(){

rm /home/vps/public_html -rf
rm /etc/nginx/sites-* -rf
rm /etc/nginx/nginx.conf -rf
sleep 1
mkdir -p /home/vps/public_html

# Creating nginx config for our webserver
cat <<'myNginxC' > /etc/nginx/nginx.conf

user www-data;

worker_processes 1;
pid /var/run/nginx.pid;

events {
	multi_accept on;
  worker_connections 1024;
}

http {
	gzip on;
	gzip_vary on;
	gzip_comp_level 5;
	gzip_types    text/plain application/x-javascript text/xml text/css;

	autoindex on;
  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  server_tokens off;
  include /etc/nginx/mime.types;
  default_type application/octet-stream;
  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;
  client_max_body_size 32M;
	client_header_buffer_size 8m;
	large_client_header_buffers 8 8m;

	fastcgi_buffer_size 8m;
	fastcgi_buffers 8 8m;

	fastcgi_read_timeout 600;


  include /etc/nginx/conf.d/*.conf;
}

myNginxC

# Creating vps config for our OCS Panel
cat <<'myvpsC' > /etc/nginx/conf.d/vps.conf
server {
  listen       Nginx_Port;
  server_name  127.0.0.1 localhost;
  access_log /var/log/nginx/vps-access.log;
  error_log /var/log/nginx/vps-error.log error;
  root   /home/vps/public_html;

  location / {
    index  index.html index.htm index.php;
    try_files $uri $uri/ /index.php?$args;
  }

  location ~ \.php$ {
    include /etc/nginx/fastcgi_params;
    fastcgi_pass  127.0.0.1:Php_Socket;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
  }
}

myvpsC

# Creating monitoring config for our OpenVPN Monitoring Panel
cat <<'myMonitoringC' > /etc/nginx/conf.d/monitoring.conf

server {
    listen Fog_Openvpn_Monitoring;
    location / {
        uwsgi_pass unix:///run/uwsgi/app/openvpn-monitor/socket;
        include uwsgi_params;
    }
}

myMonitoringC

#this is the home page of our webserver
wget -O /home/vps/public_html/index.php "https://raw.githubusercontent.com/korn-sudo/Project-Fog/main/files/panel/index.php"


# Setting up our WebServer Ports and IP Addresses
cd
sleep 1

sed -i "s|/run/php/php7.0-fpm.sock|127.0.0.1:$Php_Socket|g" /etc/php/7.0/fpm/pool.d/www.conf
sed -i "s|Php_Socket|$Php_Socket|g" /etc/nginx/conf.d/vps.conf
sed -i "s|Nginx_Port|$Nginx_Port|g" /etc/nginx/conf.d/vps.conf
sed -i "s|Fog_Openvpn_Monitoring|$Fog_Openvpn_Monitoring|g" /etc/nginx/conf.d/monitoring.conf
sed -i "s|Fog_Openvpn_Monitoring|$Fog_Openvpn_Monitoring|g" /home/vps/public_html/index.php
sed -i "s|fogserverip|$IPADDR|g" /home/vps/public_html/index.php
sed -i "s|v2portas|65432|g" /home/vps/public_html/index.php

sed -i "s|SSH_Port1|$SSH_Port1|g" /home/vps/public_html/index.php
sed -i "s|SSH_Port2|$SSH_Port2|g" /home/vps/public_html/index.php
sed -i "s|Dropbear_Port1|$Dropbear_Port1|g" /home/vps/public_html/index.php
sed -i "s|Dropbear_Port2|$Dropbear_Port2|g" /home/vps/public_html/index.php
sed -i "s|Stunnel_Port1|$Stunnel_Port1|g" /home/vps/public_html/index.php
sed -i "s|Stunnel_Port2|$Stunnel_Port2|g" /home/vps/public_html/index.php
sed -i "s|Stunnel_Port3|$Stunnel_Port3|g" /home/vps/public_html/index.php
sed -i "s|Privoxy_Port1|$Privoxy_Port1|g" /home/vps/public_html/index.php
sed -i "s|Privoxy_Port2|$Privoxy_Port1|g" /home/vps/public_html/index.php
sed -i "s|Squid_Port1|$Squid_Port1|g" /home/vps/public_html/index.php
sed -i "s|Squid_Port2|$Squid_Port2|g" /home/vps/public_html/index.php
sed -i "s|Squid_Port3|$Squid_Port3|g" /home/vps/public_html/index.php
sed -i "s|OHP_Port1|$OHP_Port1|g" /home/vps/public_html/index.php
sed -i "s|OHP_Port2|$OHP_Port2|g" /home/vps/public_html/index.php
sed -i "s|OHP_Port3|$OHP_Port3|g" /home/vps/public_html/index.php
sed -i "s|OHP_Port4|$OHP_Port4|g" /home/vps/public_html/index.php
sed -i "s|OHP_Port5|$OHP_Port5|g" /home/vps/public_html/index.php
sed -i "s|Simple_Port1|$Simple_Port1|g" /home/vps/public_html/index.php
sed -i "s|Simple_Port2|$Simple_Port2|g" /home/vps/public_html/index.php
sed -i "s|Direct_Port1|$Direct_Port1|g" /home/vps/public_html/index.php
sed -i "s|Direct_Port2|$Direct_Port2|g" /home/vps/public_html/index.php
sed -i "s|Open_Port1|$Open_Port1|g" /home/vps/public_html/index.php
sed -i "s|Open_Port2|$Open_Port2|g" /home/vps/public_html/index.php
sed -i "s|NXPort|$Nginx_Port|g" /home/vps/public_html/index.php

service nginx restart


# Setting Up OpenVPN monitoring
wget -O /srv/openvpn-monitor.zip "https://github.com/korn-sudo/Project-Fog/raw/main/files/panel/openvpn-monitor.zip"
cd /srv
unzip -qq openvpn-monitor.zip
rm -f openvpn-monitor.zip
cd openvpn-monitor
virtualenv .
. bin/activate
pip install -r requirements.txt

#updating ports for openvpn monitoring
 sed -i "s|Tcp_Monitor_Port|$Tcp_Monitor_Port|g" /srv/openvpn-monitor/openvpn-monitor.conf
 sed -i "s|Udp_Monitor_Port|$Udp_Monitor_Port|g" /srv/openvpn-monitor/openvpn-monitor.conf


# Creating monitoring .ini for our OpenVPN Monitoring Panel
cat <<'myMonitorINI' > /etc/uwsgi/apps-available/openvpn-monitor.ini
[uwsgi]
base = /srv
project = openvpn-monitor
logto = /var/log/uwsgi/app/%(project).log
plugins = python
chdir = %(base)/%(project)
virtualenv = %(chdir)
module = openvpn-monitor:application
manage-script-name = true
mount=/openvpn-monitor=openvpn-monitor.py
myMonitorINI

ln -s /etc/uwsgi/apps-available/openvpn-monitor.ini /etc/uwsgi/apps-enabled/

# GeoIP For OpenVPN Monitor
mkdir -p /var/lib/GeoIP
wget -O /var/lib/GeoIP/GeoLite2-City.mmdb.gz "https://github.com/korn-sudo/Project-Fog/raw/main/files/panel/GeoLite2-City.mmdb.gz"
gzip -d /var/lib/GeoIP/GeoLite2-City.mmdb.gz

# Now creating all of our OpenVPN Configs 

# Smart Giga Games Promo TCP
cat <<Config1> /home/vps/public_html/Smart.Giga.Games.ovpn
# Created by blackestsaint

client
dev tun
proto tcp
setenv FRIENDLY_NAME "Server-Name"
remote $IPADDR $OpenVPN_TCP_Port
nobind
persist-key
persist-tun
comp-lzo
keepalive 10 120
tls-client
remote-cert-tls server
verb 2
auth-user-pass
cipher none
auth none
auth-nocache
auth-retry interact
connect-retry 0 1
nice -20
reneg-sec 0
redirect-gateway def1
setenv CLIENT_CERT 0

http-proxy $IPADDR $Squid_Port1
http-proxy-option VERSION 1.1
http-proxy-option CUSTOM-HEADER Host codm.garena.com
http-proxy-option CUSTOM-HEADER X-Forward-Host codm.garena.com
http-proxy-option CUSTOM-HEADER X-Forwarded-For codm.garena.com
http-proxy-option CUSTOM-HEADER Referrer codm.garena.com

<ca>
$(cat /etc/openvpn/ca.crt)
</ca>
Config1

# TNT Mobile Legends 10 Promo
cat <<Config2> /home/vps/public_html/ML10.ovpn
# Created by blackestsaint

client
dev tun
proto tcp
setenv FRIENDLY_NAME "Server-Name"
remote $IPADDR $OpenVPN_TCP_Port
nobind
persist-key
persist-tun
comp-lzo
keepalive 10 120
tls-client
remote-cert-tls server
verb 2
auth-user-pass
cipher none
auth none
auth-nocache
auth-retry interact
connect-retry 0 1
nice -20
reneg-sec 0
redirect-gateway def1
setenv CLIENT_CERT 0

http-proxy $IPADDR $Privoxy_Port1
http-proxy-option VERSION 1.1
http-proxy-option CUSTOM-HEADER ""
http-proxy-option CUSTOM-HEADER "GET https://web.mobilelegends.com HTTP/1.1"
http-proxy-option CUSTOM-HEADER Host web.mobilelegends.com
http-proxy-option CUSTOM-HEADER X-Forward-Host web.mobilelegends.com
http-proxy-option CUSTOM-HEADER X-Forwarded-For web.mobilelegends.com
http-proxy-option CUSTOM-HEADER Referrer web.mobilelegends.com

<ca>
$(cat /etc/openvpn/ca.crt)
</ca>
Config2

# Default TCP
cat <<Config3> /home/vps/public_html/Direct.TCP.ovpn
# Created by blackestsaint


client
dev tun
proto tcp
setenv FRIENDLY_NAME "Server-Name"
remote $IPADDR $OpenVPN_TCP_Port
nobind
persist-key
persist-tun
comp-lzo
keepalive 10 120
tls-client
remote-cert-tls server
verb 2
auth-user-pass
cipher none
auth none
auth-nocache
auth-retry interact
connect-retry 0 1
nice -20
reneg-sec 0
redirect-gateway def1
setenv CLIENT_CERT 0

<ca>
$(cat /etc/openvpn/ca.crt)
</ca>
Config3

# Default UDP
cat <<Config4> /home/vps/public_html/Direct.UDP.ovpn
# Created by blackestsaint

client
dev tun
proto udp
setenv FRIENDLY_NAME "Server-Name"
remote $IPADDR $OpenVPN_UDP_Port
nobind
persist-key
persist-tun
comp-lzo
keepalive 10 120
tls-client
remote-cert-tls server
verb 2
auth-user-pass
cipher none
auth none
auth-nocache
auth-retry interact
connect-retry 0 1
nice -20
reneg-sec 0
redirect-gateway def1
setenv CLIENT_CERT 0

<ca>
$(cat /etc/openvpn/ca.crt)
</ca>
Config4

# Smart Giga Stories Promo TCP
cat <<Config5> /home/vps/public_html/Smart.Giga.Stories.ovpn
# Created by blackestsaint

client
dev tun
proto tcp
setenv FRIENDLY_NAME "Server-Name"
remote $IPADDR $OpenVPN_TCP_Port
nobind
persist-key
persist-tun
comp-lzo
keepalive 10 120
tls-client
remote-cert-tls server
verb 2
auth-user-pass
cipher none
auth none
auth-nocache
auth-retry interact
connect-retry 0 1
nice -20
reneg-sec 0
redirect-gateway def1
setenv CLIENT_CERT 0

http-proxy $IPADDR $Squid_Port1
http-proxy-option VERSION 1.1
http-proxy-option CUSTOM-HEADER Host static.muscdn.com
http-proxy-option CUSTOM-HEADER X-Forward-Host static.muscdn.com
http-proxy-option CUSTOM-HEADER X-Forwarded-For static.muscdn.com
http-proxy-option CUSTOM-HEADER Referrer static.muscdn.com

<ca>
$(cat /etc/openvpn/ca.crt)
</ca>
Config5

# Renaming Server Name
 sed -i "s|Server-Name|$ServerName|g" /home/vps/public_html/Smart.Giga.Stories.ovpn
 sed -i "s|Server-Name|$ServerName|g" /home/vps/public_html/Direct.UDP.ovpn
 sed -i "s|Server-Name|$ServerName|g" /home/vps/public_html/Direct.TCP.ovpn
 sed -i "s|Server-Name|$ServerName|g" /home/vps/public_html/ML10.ovpn
 sed -i "s|Server-Name|$ServerName|g" /home/vps/public_html/Smart.Giga.Games.ovpn

 # Creating OVPN download site index.html
cat <<'mySiteOvpn' > /home/vps/public_html/projectfog.html
<!DOCTYPE html>
<html lang="en">

<!-- Openvpn Config File Download site by Gwapong Lander -->

<head><meta charset="utf-8" /><title>VPN Config File Download</title><meta name="description" content="Project Fog Server -korn" /><meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" /><meta name="theme-color" content="#000000" /><link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css"><link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet"><link href="https://cdnjs.cloudflare.com/ajax/libs/mdbootstrap/4.8.3/css/mdb.min.css" rel="stylesheet"></head><body><div class="container justify-content-center" style="margin-top:9em;margin-bottom:5em;"><div class="col-md"><div class="view"><img src="https://openvpn.net/wp-content/uploads/openvpn.jpg" class="card-img-top"><div class="mask rgba-white-slight"></div></div><div class="card"><div class="card-body"><h5 class="card-title">Project Fog Config List</h5><br /><ul 

class="list-group"><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p> Giga Games Promo <span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> For Smart, TnT and Sun </small></p><a class="btn btn-outline-success waves-effect btn-sm" 
href="http://IP-ADDRESS:NGINXPORT/Smart.Giga.Games.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li><li 

class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p> Giga Stories Promo <span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> For Smart, TnT and Sun </small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/Smart.Giga.Stories.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li><li 

class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p> Mobile Legends Promo (ML10) <span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> For any network with Mobile Legends Promo </small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/ML10.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li><li 


class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p> Openvpn Default TCP <span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> This default and cannot be use for bypassing promos.</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/Direct.TCP.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li><li 


class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p> Openvpn Default UDP <span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> This default and cannot be use for bypassing promos.</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/Direct.UDP.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li><li 

class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p> Reserved <span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> Reserve by Gwapong Lander.</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/null" style="float:right;"><i class="fa fa-download"></i> Download</a></li>

</ul></div></div></div></div></body></html>
mySiteOvpn
 
 # Setting template's correct name,IP address and nginx Port
 sed -i "s|NGINXPORT|$Nginx_Port|g" /home/vps/public_html/projectfog.html
 sed -i "s|IP-ADDRESS|$IPADDR|g" /home/vps/public_html/projectfog.html

 # Restarting nginx service
 systemctl restart nginx
 
 # Creating all .ovpn config archives
 cd /home/vps/public_html
 zip -qq -r config.zip *.ovpn
 cd

chown -R www-data:www-data /home/vps/public_html

}

function ip_address(){
  local IP="$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )"
  [ -z "${IP}" ] && IP="$( wget -qO- -t1 -T2 ipv4.icanhazip.com )"
  [ -z "${IP}" ] && IP="$( wget -qO- -t1 -T2 ipinfo.io/ip )"
  [ ! -z "${IP}" ] && echo "${IP}" || echo
} 
IPADDR="$(ip_address)"



function ConfStartup(){

# Creating startup 1 script using cat eof tricks
cat <<'kornz' > /etc/projectfogstartup
#!/bin/sh

# Deleting Expired SSH Accounts
/usr/local/sbin/korn-user-delete-expired &> /dev/null

# Firewall Protection ( Torrent, Brute Force, Port Scanning )
/usr/local/sbin/korn-turntable-fog-obs

# Setting server local time
ln -fs /usr/share/zoneinfo/Asia/Manila /etc/localtime

# Prevent DOS-like UI when installing using APT (Disabling APT interactive dialog)
export DEBIAN_FRONTEND=noninteractive

# Blacklisted
#/bin/bash /etc/vil/blacklist

# Allowing ALL TCP ports for our machine (Simple workaround for policy-based VPS)
iptables -A INPUT -s $(wget -4qO- http://ipinfo.io/ip) -p tcp -m multiport --dport 1:65535 -j ACCEPT

# Allowing OpenVPN to Forward traffic
/bin/bash /etc/openvpn/openvpn.bash

# SSR Server
/usr/local/sbin/korn-ssr-updater-fog-obs


######                 WARNING                           
###### MAKE SURE YOU ONLY PUT [FULLY WORKING APPS] 
######          WHOLE SCRIPT WILL COLLAPSE         
######         IF YOU ADD NOT WORKING SCRIPT       
######    TEST IT BEFORE ADD YOUR COMMAND HERE     
######              by: blackestsaint      

kornz

rm -rf /etc/sysctl.d/99*


 # Setting our startup script to run every machine boots 
cat <<'kornx' > /etc/systemd/system/projectfogstartup.service
[Unit] 
Description=/etc/projectfogstartup
ConditionPathExists=/etc/projectfogstartup

[Service] 
Type=forking 
ExecStart=/etc/projectfogstartup start 
TimeoutSec=0
StandardOutput=tty 
RemainAfterExit=yes 
SysVStartPriority=99 

[Install] 
WantedBy=multi-user.target
kornx

chmod +x /etc/projectfogstartup
systemctl enable projectfogstartup
systemctl start projectfogstartup

# Applying cron job 
cd
echo "SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" | crontab -
sleep 1

echo "#OHP Server
@reboot /usr/local/sbin/korn-ohp-updater-fog-obs

#Multi-login Limit ON dropbear,ssh,ssl (not included: openvpn)
@reboot /usr/local/sbin/limiter-fog-obs
@reboot /usr/local/sbin/fog-limiter-activator-obs

# Python Socks Server
@reboot /usr/local/sbin/korn-python-updater-fog-obs

# Timer for Auto-reconnect
@reboot /usr/local/sbin/disable-orasan


" >> /var/spool/cron/crontabs/root

}

###### Chokepoint for Debian and Ubuntu No.2  vvvvvv

function ConfMenu(){
echo -e " Creating Menu scripts.."

cd /usr/local/sbin/
wget -q 'https://github.com/korn-sudo/Project-Fog/raw/main/files/menu/korn2021-ubuntu.zip'
unzip -qq korn2021-ubuntu.zip
rm -f korn2021-ubuntu.zip
chmod +x ./*
dos2unix ./* &> /dev/null
sed -i 's|/etc/squid/squid.conf|/etc/privoxy/config|g' ./*
sed -i 's|http_port|listen-address|g' ./*
cd ~

wget -O /usr/bin/uninstaller-fog-obs "https://github.com/korn-sudo/Project-Fog/raw/main/files/plugins/ubuntu_unins-fog-obs"
chmod +x /usr/bin/uninstaller-fog-obs

}

###### Chokepoint for Debian and Ubuntu No.2   ^^^^^


function ports_info(){

# For Edit Port dependencies
mkdir -p /etc/project-fog/service-ports
mkdir -p /etc/project-fog/v2

echo "$SSH_Port1" > /etc/project-fog/service-ports/sshp1
echo "$SSH_Port2" > /etc/project-fog/service-ports/sshp2

echo "$OpenVPN_TCP_Port" > /etc/project-fog/service-ports/openvpn-tcp
echo "$OpenVPN_UDP_Port" > /etc/project-fog/service-ports/openvpn-udp

echo "$Squid_Port1" > /etc/project-fog/service-ports/squid1
echo "$Squid_Port2" > /etc/project-fog/service-ports/squid2
echo "$Squid_Port3" > /etc/project-fog/service-ports/squid3

echo "$Privoxy_Port1" > /etc/project-fog/service-ports/priv1
echo "$Privoxy_Port2" > /etc/project-fog/service-ports/priv2

echo "$Dropbear_Port1" > /etc/project-fog/service-ports/dropbear1
echo "$Dropbear_Port2" > /etc/project-fog/service-ports/dropbear2

echo "$Stunnel_Port2" > /etc/project-fog/service-ports/stunnel-ssh
echo "$Stunnel_Port1" > /etc/project-fog/service-ports/stunnel-drop
echo "$Stunnel_Port3" > /etc/project-fog/service-ports/stunnel-open

echo "65432" > /etc/project-fog/v2/panel_port

}

function InsV2ray(){

bash <(curl -Ls https://blog.sprov.xyz/v2-ui.sh)

sleep 1

cat <<'v2about' > /etc/project-fog/v2/about

░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░


                     ░▒▓█ ☁️ Project Fog ☁️ █▓▒░

What is V2Ray?
Multiple inbound/outbound proxies: one V2Ray instance supports in 
parallel multiple inbound and outbound protocols. Each protocol works 
independently.


Current Supported Protocols: 
1. Vmess	5. Dokodemo-door
2. Vless 	6. Socks
3. Trojan	7. HTTP
4. Shadowsocks


How to Use V2Ray?
1. Go to your browser and enter this link: 
  
   http://IP-ADDRESS:65432

2. Login Username: admin
   Login Password: admin  
3. Go to Accounts
4. Tap or click the " + " button. its color blue.
5. Add Account Tab will appear and 
   fill in and choose parameters for your V2Ray.


REMINDERS:
1. Please use port ramdomly given V2Ray Panel.
2. If you want preferred port, make sure it is not
   currently use by other services or else
   your all V2Ray connection will not work.
3. iF you accidentally hit current use port in your V2Ray config,
   A. Go to Panel > Accounts > : and delete all accounts.
   B. Go to your VPS and restart V2ray using Menu.
      or simply reboot your VPS.


Supported Platforms:
1. Windows
2. Andoid Phones
3. iPhones
4. Mac


Notes:
This V2Ray Panel is made by Sprov.
All credits to Sprov.
Check his work at: 
https://github.com/sprov065
https://blog.sprov.xyz/

░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░


v2about

sleep 1

sed -i "s|IP-ADDRESS|$IPADDR|g" /etc/project-fog/v2/about


}


function ScriptMessage(){
clear
echo ""
echo ""
echo ""
echo -e "                            ░▒▓█ ☁️ Project Fog ☁️ █▓▒░" 
echo " "
echo -e "                     This Script is FREE always and forever . . ."
echo -e "                               by: blackestsaint 🦊  "
echo ""
echo ""
echo -e "                                    Credits to:"
echo -e "                                    PHC-Ford [FordSenpai] 🐱"
echo -e "                                    Bon-chan 🦢"
echo -e "                                    lfasmpao 🐯"
echo -e "                                    ADM-Manager 🐬"
echo -e "                                    Sprov 🌤️"
echo -e "                                    WaGo-G 🔥"
echo -e "                                    PHC_JAYVEE ☣️"
echo ""
echo ""
}

function InstBadVPN(){
 # Pull BadVPN Binary 64bit or 32bit
if [ "$(getconf LONG_BIT)" == "64" ]; then
 wget -O /usr/bin/badvpn-udpgw "https://github.com/korn-sudo/Project-Fog/raw/main/files/plugins/badvpn-udpgw64"
else
 wget -O /usr/bin/badvpn-udpgw "https://github.com/korn-sudo/Project-Fog/raw/main/files/plugins/badvpn-udpgw"
fi
 # Set BadVPN to Start on Boot via .profile
 sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /root/.profile
 # Change Permission to make it Executable
 chmod +x /usr/bin/badvpn-udpgw
 # Start BadVPN via Screen
 screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300
}

function CheckRequirements(){

###### Chokepoint for Debian and Ubuntu No.3   vvvvvv
 # Not Debian OS will be force exit
 source /etc/os-release
if [[ "$ID" != 'ubuntu' ]]; then
 ScriptMessage
 echo -e "[\e[1;31mError\e[0m] This script is for Ubuntu only, exiting..." 
 exit 1
fi

 # Non-rooted machine will be force exit
 # If you're on sudo user, run `sudo su -` first before running this script
 if [[ $EUID -ne 0 ]];then
 ScriptMessage
 echo -e "[\e[1;31mError\e[0m] This script must be run as root, exiting..."
 exit 1
fi

 # (For OpenVPN) Checking it this machine have TUN Module, this is the tunneling interface of OpenVPN server
 if [[ ! -e /dev/net/tun ]]; then
 echo -e "[\e[1;31mError\e[0m] You cant use this script without TUN Module installed/embedded in your machine, file a support ticket to your machine admin about this matter"
 echo -e "[\e[1;31m-\e[0m] Script is now exiting..."
 exit 1
fi
###### Chokepoint for Debian and Ubuntu No.3  ^^^^^
}

function InstOthers(){

  # Running screenfetch
 wget -O /usr/bin/screenfetch "https://raw.githubusercontent.com/korn-sudo/Project-Fog/main/files/plugins/screenfetch"
 chmod +x /usr/bin/screenfetch
 echo "/bin/bash /etc/openvpn/openvpn.bash" >> .profile
 echo "clear" >> .profile
 echo "screenfetch" >> .profile

# Obash
cd
curl -skL "https://github.com/louigi600/obash/archive/8976fd2fa256c583769b979036f59a741730eb48.tar.gz" -o obash.tgz
tar xf obash.tgz && rm -f obash.tgz
sleep 1
cd obash-8976fd2fa256c583769b979036f59a741730eb48
make clean
make
mv -f obash /usr/local/bin/obash
cd .. && rm -rf obash-8976fd2fa256c583769b979036f59a741730eb48
cd

#alias menu
wget -O ./.bashrc "https://raw.githubusercontent.com/korn-sudo/Project-Fog/main/files/plugins/.bashrc"

#banner
cat <<'korn77' > /etc/zorro-luffy
<br><font>
<br><font>
<br><font color='green'> <b>    ░▒▓█ ☁️ Project Fog ☁️ █▓▒░</b> </br></font>
<br><font>
<br><font color='#32CD32'>: : : ★ Happy Browsing!😊 </br></font>
<br><font color='#32CD32'>: : : ★ This is FREE and Not for Sale! </br></font>
<br><font color='#FDD017'>: : : ★ Project Lead: blackestsaint 🦊</br></font>
<br><font>
<br><font color='#32CD32'>: : : ★ STRICTLY NO ACCOUNT SHARING</br></font>
<br><font color='#32CD32'>: : : ★ STRICTLY NO MULTI-LOGIN</br></font>
<br><font color='#32CD32'>: : : ★ STRICTLY NO TORRENT</br></font>
<br><font>
<br><font color='#FF00FF'>░▒▓█ VIOLATORS WILL BE BAN!!!</br></font>
<br><font>
<br><font>
korn77


#block-by-keyword
mkdir -p /etc/vil 
echo "#!/bin/bash " >> /etc/vil


# Timer Notification in menu section checker
echo " " > /etc/korn/timer-proxy
echo " " > /etc/korn/timer-seconds


#Tweak for IPV4 TCP/UDP speed and maximize capability function Status: OFF
cd
mkdir -p /etc/project-fog/others
echo "#Project Fog TCP Tweak OFF" > /etc/sysctl.conf
echo "off" > /etc/project-fog/others/tcptweaks


#for blocking by keywords notes
mkdir -p /etc/korn

echo "

             Keyword below has been blocked:
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
Ports block [ torrent related issues ]
24	25	26	50	57
105	106	109	110	143
158	209	218	220	465
587	993	995	1109	24554
60177	60179		
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::" >> /etc/korn/block-by-keyword

echo "


THIS PORT ARE BLOCK IN SERVER DUE TO TORRENT ISSUE:
WARNING! DO NOT USE THIS PORT:  
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
24	25	26	50	57
105	106	109	110	143
158	209	218	220	465
587	993	995	1109	24554
60177	60179		
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::" >> /etc/korn/warning

# Dependencies of all Editing Port scenario
mkdir -p /etc/project-fog/others
echo "24	25	26	50	57
105	106	109	110	143
158	209	218	220	465
587	993	995	1109	24554
60177	60179	450	$Php_Socket	" >> /etc/project-fog/others/banned-port

 # Setting server local time
 ln -fs /usr/share/zoneinfo/$MyVPS_Time /etc/localtime

#version of Project Fog autoscript
echo "$ver" > /etc/korn/version

# Start-up Application Verification (protection for modders)
mkdir -p /usr/lib/kshell
echo "75" > /usr/lib/kshell/libs

}

function Installation-log(){

clear
echo ""
echo " INSTALLATION FINISH! "
echo ""
echo ""
echo "Server Information: " | tee -a log-install.txt | lolcat
echo "   • Timezone       : $MyVPS_Time " tee -a log-install.txt | lolcat
echo "   • Fail2Ban       : [ON]"  | tee -a log-install.txt | lolcat
echo "   • IPtables       : [ON]"  | tee -a log-install.txt | lolcat
echo "   • Auto-Reboot    : [OFF] See menu to [ON] "  | tee -a log-install.txt
echo "   • TCP Speed Tweak: [OFF] See menu to [ON]" | tee -a log-install.txt | lolcat
echo "   • Squid Cache    : [ON]" | tee -a log-install.txt | lolcat
echo "   • IPv6           : [OFF]"  | tee -a log-install.txt  | lolcat

echo " "| tee -a log-install.txt | lolcat
echo "Automated Features:"| tee -a log-install.txt | lolcat
echo "   • Auto delete expired user account"| tee -a log-install.txt | lolcat
echo "   • Auto restart server "| tee -a log-install.txt | lolcat
echo "   • Auto disconnect multilogin users [Openvpn not included]."| tee -a log-install.txt | lolcat
echo "   • Auto configure firewall every reboot[Protection for torrent and etc..]"| tee -a log-install.txt | lolcat
echo "   • Auto updated firewall[if port change,removed or add,firewall will adapt your new port]"| tee -a log-install.txt | lolcat
echo "   • Auto updated OHP[Over-HTTP-Puncher]working even theres changes in ports"| tee -a log-install.txt | lolcat

echo " " | tee -a log-install.txt | lolcat
echo "Services & Port Information:" | tee -a log-install.txt | lolcat
echo "   • OpenVPN              : [ON] : TCP: $OpenVPN_TCP_Port | UDP: $OpenVPN_UDP_Port" | tee -a log-install.txt | lolcat
echo "   • Dropbear             : [ON] : $Dropbear_Port1 | $Dropbear_Port2 " | tee -a log-install.txt | lolcat
echo "   • Squid Proxy          : [ON] : $Squid_Port1 | $Squid_Port2 |$Squid_Port3 | limit to IP Server" | tee -a log-install.txt | lolcat
echo "   • Privoxy              : [ON] : $Privoxy_Port1 | $Privoxy_Port2 | limit to IP Server" | tee -a log-install.txt | lolcat
echo "   • SSL through Dropbear : [ON] : $Stunnel_Port1  " | tee -a log-install.txt | lolcat
echo "   • SSL through OpenSSH  : [ON] : $Stunnel_Port2" | tee -a log-install.txt | lolcat
echo "   • SSL through Openvpn  : [ON] : $Stunnel_Port3 " | tee -a log-install.txt | lolcat
echo "   • OHP [through Squid]  : [ON] : $OHP_Port1 | $OHP_Port2 " | tee -a log-install.txt | lolcat
echo "   • OHP [through Privoxy]: [ON] : $OHP_Port3 | $OHP_Port4 " | tee -a log-install.txt | lolcat
echo "   • OHP [through Openvpn]: [ON] : $OHP_Port5 " | tee -a log-install.txt | lolcat
echo "   • Simple Socks Proxy   : [ON] : $Simple_Port1 | $Simple_Port2 " | tee -a log-install.txt | lolcat
echo "   • Direct Socks Proxy   : [ON] : $Direct_Port1 | $Direct_Port2 " | tee -a log-install.txt | lolcat
echo "   • Openvpn Socks Proxy  : [ON] : $Open_Port1   | $Open_Port2 " | tee -a log-install.txt | lolcat
echo "   • ShadowsocksR Server  : [OFF] : Configure through menu " | tee -a log-install.txt | lolcat
echo "   • BADVPN               : [ON] : 7300 " | tee -a log-install.txt | lolcat
echo "   • Additional SSHD Port : [ON] :  $SSH_Port2" | tee -a log-install.txt | lolcat
echo "   • OCS Panel 		: [ON] : http://$IPADDR:$Nginx_Port" | tee -a log-install.txt | lolcat
echo "   • Openvpn Monitoring   : [ON] : http://$IPADDR:$Fog_Openvpn_Monitoring" | tee -a log-install.txt | lolcat
echo "   • V2ray Panel          : [ON] : http://$IPADDR:65432 " | tee -a log-install.txt | lolcat

echo "" | tee -a log-install.txt | lolcat
echo "Notes:" | tee -a log-install.txt | lolcat
echo "  ★ Edit/Change/Off/On your OHP Port and Python Socks [see in menu option] " | tee -a log-install.txt | lolcat
echo "  ★ Torrent Protection [ add newest torrent port] " | tee -a log-install.txt | lolcat
echo "  ★ Port Scanner Basic Protection  " | tee -a log-install.txt | lolcat
echo "  ★ Brute Force Attack Basic Protection  " | tee -a log-install.txt | lolcat
echo "  ★ All ports can be edited in Edit Menu. OHP and Socks Proxy adapt new port. " | tee -a log-install.txt | lolcat
echo "  ★ Multi-login Limit customize per user [see menu]. " | tee -a log-install.txt | lolcat
echo "  ★ To display list of commands: " [ menu ] or [ menu fog ] "" | tee -a log-install.txt | lolcat
echo "" | tee -a log-install.txt | lolcat
echo "  ★ Other concern and questions of these auto-scripts?" | tee -a log-install.txt | lolcat
echo "    Direct Messege : www.facebook.com/kornips" | tee -a log-install.txt | lolcat
echo ""
read -p " Press enter.."
}


function Complete-reboot(){
clear
echo ""
echo ""
figlet Project Fog -c | lolcat
echo ""
echo "       Installation Complete! System need to reboot to apply all changes! "
read -p "                      Press Enter to reboot..."
reboot
}


#########################################################
###             Installation Begins...
#########################################################

# Filtering Machine did not meet Requirements
echo "Checking if your Server meet the requirements . . . "
CheckRequirements

ScriptMessage
sleep 2

#System Upgrade and Updates
echo " Installing Operating System Updates"
InstUpdates

# Configure OpenSSH and Dropbear
echo " Configuring ssh..."
InstSSH

# Configure Stunnel
echo " Configuring stunnel..."
InsStunnel

# Configure BadVPN UDPGW
echo " Configuring BadVPN UDPGW..."
InstBadVPN

# Configure Webmin
echo " Configuring webmin..."
InstWebmin

# Configure Squid and Privoxy
echo " Configuring proxy..."
InsProxy

# Configure Over-HTTP-Puncher
echo " Configuring Over-HTTP-Puncher..."
InsOHP

# Configure Python Socks Proxy
echo " Configuring Python Socks Proxy..."
InsPython

# Configure Shadowsocks R
echo " Configuring Shadowsocks R..."
InsShodowSocks

# Configure OpenVPN
echo " Configuring OpenVPN..."
InsOpenVPN

# Configuring Nginx OVPN config download site
echo " Configuring OpenVPN Config File and Panel Services..."
FogPanel

# Some assistance and startup scripts
echo " Configuring Startup Application Automation..."
ConfStartup

# VPS Menu script v1.0
echo " Configuring Main Dish Menu..."
ConfMenu

# Saving all Ports Information
echo " Saving all Ports Information..."
ports_info

# Configure OpenVPN
echo " Configuring V2Ray..."
InsV2ray

# Others Services ( Screenfetch, Setting Local, TCP Tweak )
echo " Adding other services..."
InstOthers

#Server Information and Details
echo "READ ME!"
Installation-log

#Final Touch (Reboot Remark)
Complete-reboot

 clear
 cd ~
 
rm /root/fog-debian -rf

exit 1
