#!/bin/sh
#
####################################
# Spotitunes for Tmux
# written by Jeff Wang
# created 2013.09.24
####################################


arg=$1;
case $arg in
    "itunes" ) state=`osascript -e 'tell application "iTunes" to player state as string'`;
        #echo "iTunes is currently $state.";
        play='-'
        if [ $state = "playing" -o $state = "paused" ]; then
            if [ $state = "playing" ]; then
                play="#[fg=green]▶#[default]"
            fi
            artist=`osascript -e 'tell application "iTunes" to artist of current track as string'`;
            track=`osascript -e 'tell application "iTunes" to name of current track as string'`;
            info="$artist: $track";
            echo "| $play | $info ";
        fi
        break ;;

    "spotify" ) state=`osascript -e 'tell application "Spotify" to player state as string'`;
        play='-'
        if [ $state = "playing" -o $state = "paused" ]; then
            if [ $state = "playing" ]; then
                play="#[fg=green]▶#[default]"
            fi
            artist=`osascript -e 'tell application "Spotify" to artist of current track as string'`;
            track=`osascript -e 'tell application "Spotify" to name of current track as string'`;
            info="$artist: $track";
            echo "| $play | $info ";
        fi
        break ;;

    "help" | * ) echo "help:";
        showHelp;
        break ;;
esac
