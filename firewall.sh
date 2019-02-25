#!/bin/bash

# Listing des operations du firewall
echo "Listing des operations du firewall active"
iptables -L -n --line-numbers

# Desactivation de toutes les entrees
echo "Desactivation de toutes les chaines (I/O/F)"
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Suppression des regles
echo "Suppression des regles"
iptables -F
iptables -X

# Autorisation d'echange avec le serveur DNS
echo "Autorisation d'echange avec le serveur DNS"
iptables -t filter -A OUTPUT -p udp --dport 53\
 -m conntrack --ctstate NEW -j ACCEPT
iptables -t filter -A INPUT -p udp --sport 53\
 -m conntrack --ctstate ESTABLISHED -j ACCEPT

# Autorisation du reseau local
echo "Autorisation du reseau local"
iptables -t filter -A OUTPUT -o lo -j ACCEPT
iptables -t filter -A INPUT -i lo -j ACCEPT

# Autoriser les pings
echo "Pings Autorises"
iptables -A INPUT -i enp0s3 -p icmp -m conntrack\
 --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o enp0s3 -p icmp -m conntrack\
 --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT

# Autoriser navigation WEB (decommenter pour activer)
echo "Autoriser navigation WEB mais surtout apt"
iptables -t filter -A OUTPUT -p tcp -m multiport\
 --dports 80,443 -m conntrack --ctstate\
 NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT -p tcp -m multiport\
 --sports 80,443 -m conntrack --ctstate\
 NEW,ESTABLISHED -j ACCEPT

# Activation des proto IMAP et SMTP (decommenter pour activer)
echo "Activation des protocoles IMAP et SMTP"
iptables -A INPUT -m multiport -p tcp --sports\
 25,2525,587,465,143,993,995 -m state --state\
 ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m multiport -p tcp --dports\
 25,2525,587,465,143,993,995 -m state --state\
 ESTABLISHED -j ACCEPT

# Creation de la chaine utilisateur
echo "Configuration SSH"
iptables -t filter -N OutGoingSSH

# Transfert de l'etude des paquets destinee a SSH depuit chaine INPUT vers OutGoingSSH
iptables -I INPUT -p tcp --dport 2230 -j OutGoingSSH

# Ajout d'un prefix pour faciliter lecture des LOGS
iptables -A OutGoingSSH -j LOG --log-prefix '[OUTGOING_SSH] : '

# De meme que les 3 etapes precedente pour les connexion entrante
iptables -t filter -N InComingSSH
iptables -I OUTPUT -p tcp --sport 2230 -j InComingSSH
iptables -A InComingSSH -j LOG --log-prefix '[INCOMING_SSH] : '

# Autorisation des connexions SSH entree et sortie sur le port 2230
iptables -t filter -A INPUT -i enp0s3\
 -p tcp -m tcp --dport 2230 -m conntrack\
  --ctstate NEW,ESTABLISHED -j ACCEPT

iptables -t filter -A OUTPUT -o enp0s3\
 -p tcp -m tcp --sport 2230 -m conntrack\
 --ctstate ESTABLISHED -j ACCEPT

iptables -A OUTPUT -o enp0s3 -p tcp --dport 2230 -j ACCEPT

# Refus automatique des packets invalides
echo "Bouclier anti packet invalide"
iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP

# Reject des packets TCP, sans SYN (1er packet envoyer ~= synchro)
iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP

# Reject des packets SYN contenant des valeur MSS suspicieuses (Maximum segment size)
iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP

# Bloc les packets avec de mauvaises combinaisons
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP

# Reject des packets usurpes (spoofed packets)
iptables -t mangle -A PREROUTING -s 224.0.0.0/3 -j DROP
iptables -t mangle -A PREROUTING -s 169.254.0.0/16 -j DROP
iptables -t mangle -A PREROUTING -s 172.16.0.0/12 -j DROP
iptables -t mangle -A PREROUTING -s 192.0.2.0/24 -j DROP
iptables -t mangle -A PREROUTING -s 192.168.0.0/16 -j DROP
iptables -t mangle -A PREROUTING -s 0.0.0.0/8 -j DROP
iptables -t mangle -A PREROUTING -s 240.0.0.0/5 -j DROP
iptables -t mangle -A PREROUTING -s 127.0.0.0/8 ! -i lo -j DROP

# Reject des chaines incomplete
iptables -t mangle -A PREROUTING -f -j DROP

# Limitation des connexions par IP
iptables -A INPUT -p tcp -m connlimit --connlimit-above 111 -j REJECT\
 --reject-with tcp-reset

# Limitation des packets RST
iptables -A INPUT -p tcp --tcp-flags RST RST -m limit\
 --limit 2/s --limit-burst 2 -j ACCEPT
iptables -A INPUT -p tcp --tcp-flags RST RST -j DROP

# Limitation de connexion TCP par secondes et par sources
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m limit\
 --limit 60/s --limit-burst 20 -j ACCEPT
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -j DROP

# Application des protections (anti brute-force, anti-scan)
echo "Application des protections anti-brute-force sur ssh"
iptables -A INPUT -p tcp --dport 2230 -m conntrack --ctstate NEW -m recent --set
iptables -A INPUT -p tcp --dport 2230 -m conntrack --ctstate NEW -m recent\
 --update --seconds 60 --hitcount 10 -j DROP
echo "Application des protections anti-scan"
iptables -N port-scanning
iptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit\
 --limit 1/s --limit-burst 2 -j RETURN
iptables -A port-scanning -j DROP

# Sauvegarde des regles dans /etc/firewall-client
iptables-save > /etc/firewall-client

# Reload de la sauvegarde depuis /etc/firewall-client
iptables-restore < /etc/firewall-client

# Check de l'installation du fireWall
echo "Installation terminer:"
iptables -L -n --line-numbers
