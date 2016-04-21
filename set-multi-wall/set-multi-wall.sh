#!/bin/bash
#
# set-multi-wall.sh - Multi-monitor background image switcher
#
# Copyright (C) 2016 by Andrew L. Ayers
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 3 of the License, or (at your option) any later 
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT 
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with 
# this program; if not, write to the Free Software Foundation, Inc., 51 Franklin 
# Street, Fifth Floor, Boston, MA 02110-1301  USA
#

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Change WALLPAPERS and WAIT as needed
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# Path to wallpapers
WALLPAPERS="/home/andrew/Data/Entertainment/backgrounds"

# Transition time (in seconds)
WAIT=180

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# Last paths selected (used to avoid fade in/out of a current displayed image)
LAST_PATH0=""
LAST_PATH1=""

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

show_old_background() {
    # First run, so if a prior last (old) background exists, show it
    if [ -s "/tmp/last0.bg" ]; then
        feh --image-bg black --bg-max /tmp/last0.bg /tmp/last1.bg
    else
        # Otherwise, grab a new set of background(s)    
        show_new_background
    fi
}

show_new_background() {
    # randomly get a section
    get_random_section
    
    local SECTION=$RVAL
    
    # randomly select a line
    get_random_line $SECTION
    
    local WPATH=$WALLPAPERS/$SECTION
    local WORDS=( ${RVAL[@]} )
    local WORD0=${WORDS[0]} 
    local WORD1=${WORDS[1]}

    # randomly get files
    get_random_files $WPATH $WORD0 $WORD1

    local FILES=( ${RVAL[@]} )
    local PATH0=$WPATH/"${WORD0/\*/${FILES[0]}}" 
    local PATH1=$WPATH/"${WORD1/\*/${FILES[1]}}"

    fade_new_background $PATH0 $PATH1
}

get_random_section () {
    # Extract all sections
    local SECTIONS=( `egrep "\\[.*\\]" $WALLPAPERS/wallpapers.cfg` )

    # Pick a random section
    local RANGE=${#SECTIONS[*]}
    local SHOW=$(( $RANDOM % $RANGE ))
    local SECTION=${SECTIONS[$SHOW]}

    RVAL=(`echo $SECTION | tr -d '[]'`)
}

get_random_line () {
    local SECTION=$1
    
    # Set IFS to break on linefeeds, then put in array:
    #
    #   1. get control file
    #   2. Use sed to find section
    #   3. Use sed to remove 1st and last lines
    #   4. Use sed to skip blank lines
    #
    IFS=$'\n'
    local LINES=( `cat $WALLPAPERS/wallpapers.cfg | sed -n "/\[$SECTION\]/,/\[/p" | sed '1d;$d' | sed '/^$/d'` )

    local RANGE=${#LINES[*]}
    local SHOW=$(( $RANDOM % $RANGE ))
    local LINE=${LINES[$SHOW]}

    # Reset IFS to default (space, tab, newline)
    # and extract WORDS from LINE to an array
    IFS=$' ^I$'
    RVAL=( `echo $LINE` )
}

get_random_files() {
    local WPATH=$1
    
    local WORD0=$2
    local WORD1=$3

    # Extract all horizontal files
    local FILES0=($WPATH/$WORD0)
    local FILES0=("${FILES0[@]##*/}") 

    # Extract all vertical files
    local FILES1=($WPATH/$WORD1)
    local FILES1=("${FILES1[@]##*/}") 

    # Pick a random horizontal file
    local RANGE=${#FILES0[@]}
    local SHOW=$(( $RANDOM % $RANGE ))
    local FILE0=${FILES0[$SHOW]}

    # Pick a random vertical file
    local RANGE=${#FILES1[@]}
    local SHOW=$(( $RANDOM % $RANGE ))
    local FILE1=${FILES1[$SHOW]}
    
    # Set IFS to break on linefeeds, then put in array
    IFS=$'\n'
    RVAL=( `echo $FILE0; echo $FILE1` )
}

fade_new_background() {
    local PATH0=$1
    local PATH1=$2

    fade_new_backgrounds $PATH0 $PATH1
    
    show_new_backgrounds $PATH0 $PATH1
}

fade_new_backgrounds() {
    # Copy the selected backgrounds to the new backgrounds
    cp $1 /tmp/new0.bg
    cp $2 /tmp/new1.bg
    
    # Fade transitions for last to new backgrounds
    convert /tmp/last0.bg -fill black -colorize 25% /tmp/tran01.bg
    convert /tmp/last1.bg -fill black -colorize 25% /tmp/tran11.bg

    convert /tmp/last0.bg -fill black -colorize 50% /tmp/tran02.bg
    convert /tmp/last1.bg -fill black -colorize 50% /tmp/tran12.bg

    convert /tmp/last0.bg -fill black -colorize 75% /tmp/tran03.bg
    convert /tmp/last1.bg -fill black -colorize 75% /tmp/tran13.bg    

    convert /tmp/new0.bg -fill black -colorize 50% /tmp/tran04.bg
    convert /tmp/new1.bg -fill black -colorize 50% /tmp/tran14.bg    

    convert /tmp/new0.bg -fill black -colorize 25% /tmp/tran05.bg
    convert /tmp/new1.bg -fill black -colorize 25% /tmp/tran15.bg    
}

show_new_backgrounds() {
    local PATH0=$1
    local PATH1=$2
    local DISPLAY0="/tmp/new0.bg";
    local DISPLAY1="/tmp/new1.bg";

    for i in `seq 1 5`; do
        # Transition both displays (most common)
        if [ "$PATH0" != "$LAST_PATH0" ] && [ "$PATH1" != "$LAST_PATH1" ]; then
            feh --image-bg black --bg-max /tmp/tran0$i.bg /tmp/tran1$i.bg
            continue
        fi
    
        # Transition display 0 only
        if [ "$PATH0" != "$LAST_PATH0" ] && [ "$PATH1" == "$LAST_PATH1" ]; then
            feh --image-bg black --bg-max /tmp/tran0$i.bg $DISPLAY1
            continue
        fi

        # Transition display 1 only
        if [ "$PATH0" == "$LAST_PATH0" ] && [ "$PATH1" != "$LAST_PATH1" ]; then
            feh --image-bg black --bg-max $DISPLAY0 /tmp/tran1$i.bg
        fi        
    done

    # Set new background (full brightness)
    feh --image-bg black --bg-max /tmp/new0.bg /tmp/new1.bg
    
    # Set last backgrounds to current backgrounds
    mv /tmp/new0.bg /tmp/last0.bg; mv /tmp/new1.bg /tmp/last1.bg
    
    # Remove transition backgrounds
    rm /tmp/tran*.bg
    
    LAST_PATH0=$PATH0
    LAST_PATH1=$PATH1
}

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# Set the current display (necessary when kicked off at login)
DISPLAY=:0.0

# Otherwise, continue as normal
while true; do
    if [ -z "$RUNNING" ]; then
        # If -now parameter was passed, then show a new background
        if [ "$1" == "-now" ]; then 
            show_new_background
        else
            show_old_background                
        fi

        # If the script is already running as another process, exit
        pid=`pidof -x set-multi-wall.sh`; if [ "$pid" != "$$" ]; then exit 0; fi
    else
        show_new_background        
    fi
    
    RUNNING="yes"

    sleep $WAIT
done
