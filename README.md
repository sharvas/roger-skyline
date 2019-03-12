# SysAdmin 101 - setting up the VM, network, security and SSL web server

The second sysadmin project for the basics of system and network administration. The project consists of three parts: setting up the VM, network, security and the web server. For the details please check out the [subject](https://github.com/sharvas/roger_skyline/raw/master/roger-skyline-1.5.en.pdf).

***VM part:***
* setting up a VM with the chosen Linux distribution

***Network and Security part:***
* configuring static IP
* configuring SSH service
* setting up the firewall
* protection against DOS
* protection against port scans
* scripts for system update and crontab monitor

***Web part:***
* web server configuration with Apache or Nginx
* SSL configuration on all services
* hosting a web app in the local network
* deployment script for the web app

Latest **Debian(amd64)** version was installed on the VM, that was set up with **VirtualBox**.

```console
sarunas@debian:~$ sudo service --status-all
 [ - ]  console-setup.sh
 [ + ]  cron
 [ + ]  dbus
 [ + ]  fail2ban
 [ - ]  hwclock.sh
 [ - ]  keyboard-setup.sh
 [ + ]  kmod
 [ + ]  netfilter-persistent
 [ + ]  networking
 [ + ]  nginx
 [ + ]  procps
 [ - ]  rsync
 [ + ]  rsyslog
 [ + ]  ssh
 [ - ]  sudo
 [ + ]  udev
```

Firewall was set up using **iptables** and **iptables-persistent**.

DOS protection was set up with **fail2ban** and rules in iptables.

Web server was configured with **nginx**, SSL key and certificate were generated with **openssl**. The deployment was implemented through Github.

**Useful intformation**:
* https://www.thegeekstuff.com/2011/01/iptables-fundamentals/
* http://blog.sevagas.com/?Iptables-firewall-versus-nmap-and-hping3
* http://blog.sevagas.com/?Iptables-firewall-versus-nmap-and,31
* http://blog.sevagas.com/?Iptables-firewall-versus-nmap-and-hping3-32
* https://superuser.com/questions/900074/does-the-dhcp-server-know-about-static-ip-addresses
* https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-on-debian-9
