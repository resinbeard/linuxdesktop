. /etc/X11/xinit/xinitrc.d/*
export XDG_MENU_PREFIX=gnome-

#!/bin/sh
xset b off
eval "$(gpg-agent --daemon)"
urxvtd -q -f -o &
amixer -q set Headphone mute &
compton &
hsetroot -solid "#ffffff" -center Pictures/redwoods3.jpg &
#dbus-send --system --type=method_call --print-reply=literal --dest=org.bluez /org/bluez/hci0 org.freedesktop.DBus.Properties.Set string:org.bluez.Adapter1 string:Powered variant:boolean:true &
hcitool scan &
sudo hciconfig hci0 up &
#bluez-test-audio connect 0C:A6:94:B2:F6:F8 &
synclient TapButton3=3

cpu(){
    echo `top -bn1 | grep "Cpu(s)" |            sed "s/.*, *\([0-9.]*\)%* id.*/\1/" |            awk '{print 100 - $1"%"}'`
    }

wifi(){
      STATUS="X`wpa_cli status | sed -n '4p'`"
      if test "$STATUS" != "X" ; then
        ESSID="`wpa_cli status | sed -n '4p' | awk -F "=" '{print $2}'| sed -e 's/"//g'`"
        LINK=""
      echo "essid:$ESSID"
      fi
    } 

volume(){
      STATUS="`amixer get Master |awk '/Front\ Left:/ {print $6}'`"
      if test "$STATUS" != "[on]" ; then 
        echo " Mute"
      else
        echo "`/usr/bin/amixer get Master |awk '/Front\ Left:/ {print $5}' | sed -e 's/\[//g'|sed -e 's/%\]//g'`"
      fi
    }

while true; do
BAT="Bat. $(acpi -b | awk '{ print $4 }' | tr -d ',')"
  xsetroot -name "`wifi` cpu:`cpu` vol:`volume`% $BAT `date '+%a %Y%m%d %H:%M'`"
  sleep 1
done &

exec dwm
