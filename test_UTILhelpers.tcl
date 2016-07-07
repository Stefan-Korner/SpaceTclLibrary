#!/bin/sh
# \
exec tclsh "$0" ${1+"$@"}
#******************************************************************************
# (C) 2016, Stefan Korner, Austria                                            *
#                                                                             *
# The Space Tcl Library is free software; you can redistribute it and/or      *
# modify it under the terms of the GNU Lesser General Public License as       *
# published by the Free Software Foundation; either version 2.1 of the        *
# License, or (at your option) any later version.                             *
#                                                                             *
# The Space Tcl Library is distributed in the hope that it will be useful,    *
# but WITHOUT ANY WARRANTY; without even the implied warranty of              *
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser     *
# General Public License for more details.                                    *
#******************************************************************************
# unit test for helpers                                                       *
#******************************************************************************
lappend auto_path $env(PWD)   # load procedures defined in tclIndex

set binData1 "a0123456789abcmnoABCMNO"
puts "binData1 = $binData1"
set hexData1 [bin2hex $binData1]
puts "hexData1 = $hexData1"
set binData2 [hex2bin $hexData1]
puts "binData2 = $binData2"
