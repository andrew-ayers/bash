#!/bin/bash
#
# killnamed.sh - Kill processes by named string
#
# Copyright (C) 2014-2016 by Andrew L. Ayers
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

# Get an array of process IDs, stripping off the header of the
# column (pid=), and looking for a given name pattern (-C). Pipe
# the output to "translate" and delete and spaces (trim)
pids=`ps -o pid= -C indicator-cpufreq | tr -d ' '`

# Loop thru the array of process IDs
for i in "${pids[@]}"
do
    # ...killing each one
    kill -9 $i
done
