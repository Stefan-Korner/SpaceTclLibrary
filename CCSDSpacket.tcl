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
# CCSDS and PUS Packet processing                                             *
#******************************************************************************
namespace eval CCSDSpacket {}

################################
# sequence counter calculation #
################################

global CCSDSpacket::sequenceCounters 

# returns the next SSC for a defined APID
proc CCSDSpacket::getNextSSC {apid} {
  global CCSDSpacket::sequenceCounters
  if {[info exists CCSDSpacket::sequenceCounters($apid)]} {
    incr CCSDSpacket::sequenceCounters($apid)
    if {$CCSDSpacket::sequenceCounters($apid) > 16383} {
      set CCSDSpacket::sequenceCounters($apid) 0
    }
  } else {
    set CCSDSpacket::sequenceCounters($apid) 0
  }
  return $CCSDSpacket::sequenceCounters($apid)
}

# resets the SSC for a defined APID
proc CCSDSpacket::resetSSC {apid} {
  global CCSDSpacket::sequenceCounters
  if {[info exists CCSDSpacket::sequenceCounters($apid)]} {
    unset CCSDSpacket::sequenceCounters($apid)
  }
}
