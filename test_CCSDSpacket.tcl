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
# unit tests for CCSDS and PUS Packet processing                              *
#******************************************************************************
source CCSDSpacket.tcl

set apid 1234
set pusType 3
set pusSubType 25
set hexData "FFFF"
puts [CCSDSpacket::createTmPkt $apid $pusType $pusSubType $hexData]
puts [CCSDSpacket::createTmPkt $apid $pusType $pusSubType $hexData]
puts [CCSDSpacket::createTmPkt $apid $pusType $pusSubType $hexData]
puts [CCSDSpacket::createTmPkt $apid $pusType $pusSubType $hexData]
puts [CCSDSpacket::createTmPkt $apid $pusType $pusSubType $hexData]
