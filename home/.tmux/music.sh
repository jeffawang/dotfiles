#!/bin/sh
#
####################################
# Spotitunes for Tmux
# written by Jeff Wang
# created 2013.09.24
####################################

for arg in "$@"
do
  # arg=$1;
  case $arg in
      "itunes" ) 
          a='iTunes';
          ;;
  
      "spotify" ) 
          a='Spotify';
          ;;
  
      "help" | * )
          echo "Please specify 'itunes' or 'spotify'"
          continue
          # exit 1
          ;;
  esac
  [[ -n $a ]] && osascript <<EOF
  if application "$a" is running then
    try
      tell application "$a"
        set theName to name of the current track
        set theArtist to artist of the current track
        set theAlbum to album of the current track
        set state to player state as string
        if state is "playing"
            set p to "#[fg=green]▶#[default]"
        else
            set p to "-"
        end if
          return "| " & p & " | " & theArtist & ": " & theName & " "
      end tell
    end try
  end if
EOF
done
