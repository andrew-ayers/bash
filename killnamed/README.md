# killnamed.sh - Kill processes by named string

### About ###

This script will kill processes which have a particular string associated with 
them; in this case, "indicator-cpufreq", which is actually kicked off by the 
python interpreter, as so:

/usr/bin/python3 /usr/bin/indicator-cpufreq

Since an ordinary killall or pkill can't touch this by name, and we may not want 
to kill all python3 processes, we need to do something like this script.

### License ###

Copyright (C) 2014-2016 by Andrew L. Ayers

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
