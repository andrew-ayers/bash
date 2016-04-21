# set-multi-wall.sh - Multi-monitor background image switcher#

### Features ###

* Uses feh (https://feh.finalrewind.org/) to update backgrounds
* Uses imagemagick (http://www.imagemagick.org/script/index.php) for transition effect
* Currently only handles two monitors (could be expanded to handle more)
* Easy to configure (see below)

### About ###

After configuring my Ubuntu 14.04 LTS box to look and work more like #! (which 
at the time was still kinda long-in-the-tooth - then it was shut down - then 
ressurected - but not quite - meh), I wanted to have means to update my 
backgrounds dynamically. 

Nothing that I could find would do everything I wanted; mainly I wanted random 
images, on different monitors, fade-in/out, configurable delay between images. 
Most tools only did a couple of those features, or only changed the background
on startup. Maybe I needed to look around some more, but I figured the time might
be better spent coming up with my own solution.

For some reason (because I am a masochist?) I wanted to do this using a Bash
script. I contemplated Perl, I thought about PHP, I considered Python, C/C++ 
seemed like overkill. I thought that Bash might be perfect, but I still needed a
way to get an image to the background. A bit of research on #! and Arch Linux gave
me the answer. To the rescue came feh.

After a bit of openbox config hacking I got something working, but the screen 
transitions were jarring (especially when you have transparent windows involved). 
So I set out to fix that issue. My first try worked well, but the transitions were 
kinda jerky. They weren't as jarring as before, but not perfect. 

I left things like that for a long while, then I recently got a dual-monitor 
stand, and decided to turn one of my monitors to a portrait orientation (great
for code and reading long docs). Unfortunately, my backgrounds no longer worked
properly, to put it simply. The main issue was centering, which I knew was
going to be an easy fix to the feh command. So, I decided to fix that issue, and 
while I was in there, a few others, and what I came up with is what you see here.

### Configuration ###

To set it all up, put the script somewhere and make it executable. Modify the 
lines in the script to point to where your background images are stored (WALLPAPERS), 
and to determine how often you want to swap images (WAIT - default is 180 seconds, 
or 3 minutes).

Create your wallpapers.cfg file, and put it in the path set by WALLPAPERS. For my
system, I then modified my openbox autostart config file ($HOME/.config/openbox/autostart.sh) to 
kick off the program when I logged in:

($HOME/set-multi-wall.sh) &

You may need to do something different, but it shouldn't be anything too difficult 
to set up. If you need some help, give me a shout (see below), I'll see what I 
can do.

### Operation and Arguments ###

When the script is executed, it enters into an infinite loop, which controls how
and when (WAIT) to change the background.

In this loop, it first checks to see if it is already running. If it isn't, a
check is then made to see if an argument of "-now" was passed on the command 
line:

$HOME/set-multi-wall.sh -now

If that argument was passed, then a new set of background images are displayed, 
otherwise the old set is displayed. 

It then checks to see if the current process ID matches one existing process 
with the same name (set-multi-wall.sh); if it doesn't, it exits immediately.

This is done so that multiple set-multi-wall.sh processes don't "stack up", each
sitting in their own infinite loops, changing the images out from under each other
willy-nilly. Instead, it ensures only one process at a time will run, and if
there are multiple copies running, it will only run to display the old selected
images, or a new set (if "-now" is passed).

Otherwise, if the loop is already running, then it displays a new set of images,
and then sleeps (for WAIT seconds).

### TODO ###

* Configurable number of monitors?
* Different image transition effects?
* Window border colors to match background?
* Method to remotely shut down ricers with fart-can exhausts?

### License ###

Copyright (C) 2016 by Andrew L. Ayers

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 3 of the License, or (at your option) any later 
version.

This program is distributed in the hope that it will be useful, but WITHOUT 
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with 
this program; if not, write to the Free Software Foundation, Inc., 51 Franklin 
Street, Fifth Floor, Boston, MA 02110-1301  USA

### Who do I cuss out? ###

* Andrew L. Ayers - junkbotix@gmail.com
* http://www.phoenixgarage.org/
