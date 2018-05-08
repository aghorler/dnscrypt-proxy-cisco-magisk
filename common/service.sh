#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode
# More info in the main Magisk thread

while true
do
  ping -c 1 cloudflare-dns.com
  if [[ $? == 0 ]];
  then
    $MODDIR/system/xbin/dnscrypt-proxy -config $MODDIR/system/etc/dnscrypt-proxy/dnscrypt-proxy.toml &
    sleep 5
    iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination 127.0.0.1:5354
    iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 127.0.0.1:5354
    ip6tables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination [::1]:5354
    ip6tables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination [::1]:5354
    break;
  else
    sleep 5
  fi
done
