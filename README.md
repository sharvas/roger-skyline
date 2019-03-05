# sysadmin 101

The second sysadmin project for the basics of system and network administration. The project consists of three parts: setting up the VM, network, security and the web server. For the details please check out the [subject](https://github.com/sharvas/roger_skyline/raw/master/roger-skyline-1.5.en.pdf).

***VM part:***
* setting up a VM with the chosen Linux distribution

***Network and Security part:***
* configuring static IP
* configuring SSH service
* setting up firewall
* protection against DOS
* protection agains port scans
* scripts for system update and crontab monitor

***Web part:***
* web server configuration with Apache or Nginx
* SSL configuration on all services
* hosting a web app in the local network
* deployment script for the web app

For the Linux distribution latest **Debian(amd64)** version was chosen and VM was set up with **VirtualBox**.
Only SSH server and standard system utilities were intalled during the instalation.

```bash
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

Network configured (```/etc/network/interfaces```) as bridged. And an IP address suggested by DHCP was used to set as static with the netmask of /30. SSH configured (```/etc/ssh/sshd_config```) by setting a custom port for connections, access enabled only with pubkeys and root access disabled.

Firewall was set up by using **iptables** and **iptables-persistent**.
DOS protection was set up with **fail2ban** and rules in iptables.

Web server configured with **nginx**, SSL key and certificate were generated with **openssl**. Deployment was implemented through Github.

**Some useful intformation**:
* https://www.thegeekstuff.com/2011/01/iptables-fundamentals/
* http://blog.sevagas.com/?Iptables-firewall-versus-nmap-and-hping3
* http://blog.sevagas.com/?Iptables-firewall-versus-nmap-and,31
* http://blog.sevagas.com/?Iptables-firewall-versus-nmap-and-hping3-32
* https://superuser.com/questions/900074/does-the-dhcp-server-know-about-static-ip-addresses
* https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-on-debian-9

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEzMzY1ODMyMTksLTcxNDExMTM4NiwtNT
E5NzQwMjA2LC0xMzAxODE0MTEyLC0xMzY3OTY5ODY1XX0=
-->
