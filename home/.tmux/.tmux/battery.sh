#!/bin/sh

HEART_FULL=♥
HEART_EMPTY=♡
[ -z "$NUM_HEARTS" ] &&
    NUM_HEARTS=5

cutinate()
{
    perc=$1
    inc=$(( 100 / $NUM_HEARTS))
    HEARTS=""


    for i in `seq $NUM_HEARTS`; do
        if [ $perc -lt 100 ]; then
            HEARTS+="$HEART_EMPTY"
        else
            HEARTS+="$HEART_FULL"
        fi
        perc=$(( $perc + $inc ))
    done
    echo $HEARTS
}

linux_get_bat ()
{
    bf=$(cat $BAT_FULL)
    bn=$(cat $BAT_NOW)
    echo $(( 100 * $bn / $bf ))
}

freebsd_get_bat ()
{
    sysctl -n hw.acpi.battery.life
}

# Do with grep and awk unless too hard

# TODO Identify which machine we're on from teh script.

battery_status()
{
case $(uname -s) in
    "Linux")
        BATPATH=${BATPATH:-/sys/class/power_supply/BAT0}
        STATUS=$BATPATH/status
        [ "$1" = `cat $STATUS` ] || [ "$1" = "" ] || return 0
        if [ -f "$BATPATH/energy_full" ]; then
            naming="energy"
        elif [ -f "$BATPATH/charge_full" ]; then
            naming="charge"
        elif [ -f "$BATPATH/capacity" ]; then
            cat "$BATPATH/capacity"
            return 0
        fi
        BAT_FULL=$BATPATH/${naming}_full
        BAT_NOW=$BATPATH/${naming}_now
        linux_get_bat
        ;;
    "FreeBSD")
        STATUS=`sysctl -n hw.acpi.battery.state`
        case $1 in
            "Discharging")
                if [ $STATUS -eq 1 ]; then
                    freebsd_get_bat
                fi
                ;;
            "Charging")
                if [ $STATUS -eq 2 ]; then
                    freebsd_get_bat
                fi
                ;;
            "")
                freebsd_get_bat
                ;;
        esac
        ;;
    "Darwin")
        case $1 in
            "Discharging")
                ext="No";;
            "Charging")
                ext="Yes";;
        esac

        ioreg -c AppleSmartBattery -w0 | \
        grep -o '"[^"]*" = [^ ]*' | \
        sed -e 's/= //g' -e 's/"//g' | \
        sort | \
        while read key value; do
            case $key in
                "MaxCapacity")
                    export maxcap=$value;;
                "CurrentCapacity")
                    export curcap=$value;;
                "ExternalConnected")
                    if [ -n "$ext" ] && [ "$ext" != "$value" ]; then
                        exit
                    fi
                ;;
                "FullyCharged")
                    if [ "$value" = "Yes" ]; then
                        exit
                    fi
                ;;
            esac
            if [[ -n "$maxcap" && -n $curcap ]]; then
                echo $(( 100 * $curcap / $maxcap ))
                break
            fi
        done
esac
}

battery_color()
{
    if [ $1 -lt 40 ]; then
        echo 'red'
    elif [ $1 -lt 80 ]; then
        echo 'yellow'
    else
        echo 'green'
    fi
}

BATTERY_STATUS=`battery_status $1`
[ -z "$BATTERY_STATUS" ] && exit

echo "#[fg=$(battery_color $BATTERY_STATUS)]"$(cutinate $BATTERY_STATUS)"#[default] $BATTERY_STATUS%"
