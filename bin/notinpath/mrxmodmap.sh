#!/bin/bash

echo "MR $0 mrxmodmap.sh $(date)" >>~/startup 2>&1
#xmodmap -e "clear Lock" >>~/ww/mrxmodmap 2>&1
#xmodmap -e "keycode 0x42 = Escape" >>~/ww/mrxmodmap 2>&1


setxkbmap -layout us -variant dvp -option -option caps:escape -option lv3:ralt_switch
#setxkbmap -layout us -variant dvp -option -option caps:escape -option compose:ralt
