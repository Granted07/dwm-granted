#!/bin/sh

usbmon() {

	usb1=$(lsblk -la | awk '/sdc1/ { print $1 }')

	usb1mounted=$(lsblk -la | awk '/sdc1/ { print $7 }')



	if [ "$usb1" ]; then

		if [ -z "$usb1mounted" ]; then

			echo " |"

		else

			echo " $usb1 |"

		fi

	fi

}



battery () { 

	CHARGE=$(cat /sys/class/power_supply/BAT1/capacity)
    STATUS=$(cat /sys/class/power_supply/BAT1/status)

	if [ "$STATUS" = "Discharging" ];
	then

		if [ "$CHARGE" > 80 ]
		then
			echo -n " $CHARGE"
		elif [ "$CHARGE" > 60 ]
		then
			echo -n " $CHARGE"
		elif [ "$CHARGE" > 40 ]
		then
			echo -n " $CHARGE"
		elif [ "$CHARGE" > 20 ]
		then
			echo -n " $CHARGE"
		else
			echo -n " $CHARGE"
		fi

    else

		if [ "$CHARGE" > 80 ]
		then
			echo -n "  $CHARGE"
		elif [ "$CHARGE" > 60 ]
		then
			echo -n "  $CHARGE"
		elif [ "$CHARGE" > 40 ]
		then
			echo -n "  $CHARGE"
		elif [ "$CHARGE" > 20 ]
		then
			echo -n "  $CHARGE"
		else
			echo -n "  $CHARGE"
		fi

    fi

}



fsmon() {

	ROOTPART=$(df -h | awk '/\/$/ { print $3}') 

	HOMEPART=$(df -h | awk '/\/home/ { print $3}') 

	SWAPPART=$(cat /proc/swaps | awk '/\// { print $4 }')



	echo "   $ROOTPART    $HOMEPART"

}



ram() {

	mem=$(free -h | awk '/Mem:/ { print $3 }' | cut -f1 -d 'i')

	echo  "$mem"

}



cpu() {

	read -r cpu a b c previdle rest < /proc/stat

	prevtotal=$((a+b+c+previdle))

	sleep 0.5

	read -r cpu a b c idle rest < /proc/stat

	total=$((a+b+c+idle))

	cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))

	echo  "$cpu"%

}



network() {

	conntype=$(ip route | awk '/default/ { print substr($5,1,1) }')



	if [ -z "$conntype" ]; then

		echo " down"

	elif [ "$conntype" = "e" ]; then

		echo " up"

	elif [ "$conntype" = "w" ]; then

		echo " up"

	fi

}



volume_pa() {

	muted=$(pactl list sinks | awk '/Mute:/ { print $2 }')

	vol=$(pactl list sinks | grep Volume: | awk 'FNR == 1 { print $5 }' | cut -f1 -d '%')


	if [ "$muted" = "yes" ]; then

		echo " muted"

	else

		if [ "$vol" -ge 65 ]; then

			echo " $vol%"

		elif [ "$vol" -ge 40 ]; then

			echo " $vol%"

		elif [ "$vol" -ge 0 ]; then

			echo " $vol%"	

		fi

	fi



}



volume_alsa() {



	mono=$(amixer -M sget Master | grep Mono: | awk '{ print $2 }')



	if [ -z "$mono" ]; then

		muted=$(amixer -M sget Master | awk 'FNR == 6 { print $7 }' | sed 's/[][]//g')

		vol=$(amixer -M sget Master | awk 'FNR == 6 { print $5 }' | sed 's/[][]//g; s/%//g')

	else

		muted=$(amixer -M sget Master | awk 'FNR == 5 { print $6 }' | sed 's/[][]//g')

		vol=$(amixer -M sget Master | awk 'FNR == 5 { print $4 }' | sed 's/[][]//g; s/%//g')

	fi



	if [ "$muted" = "off" ]; then

		echo " muted"

	else

		if [ "$vol" -ge 65 ]; then

			echo " $vol%"

		elif [ "$vol" -ge 40 ]; then

			echo " $vol%"

		elif [ "$vol" -ge 0 ]; then

			echo " $vol%"	

		fi

	fi

}

weather() {

	wea=$(curl -s wttr.in/Kolkata?format=1)
	echo "$wea"

}



clock() {

	dte=$(date +"%D")

	time=$(date +"%H:%M")

	echo "🗓 $dte  |   $time"

}

brightness() {

	backlight=$(brightnessctl | grep % | awk '{print $4}' | tr -d ')(')
	echo -n "☀ $backlight"

}


main() {

	while true; do

		xsetroot -name "$(weather) |  $(fsmon)  |  $(ram)  |  $(cpu)  |  $(clock)  |  $(battery)%  |  $(brightness)  |  $(volume_pa)"
		sleep 0.5

	done
}



main

