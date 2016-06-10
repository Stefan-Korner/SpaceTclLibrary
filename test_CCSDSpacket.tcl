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

###########
# tests A #
###########

set apid 1234
set pusType 3
set pusSubType 25
set hexData "FFFF"
puts [CCSDSpacket::createTmPkt $apid $pusType $pusSubType $hexData]
puts [CCSDSpacket::createTmPkt $apid $pusType $pusSubType $hexData]
puts [CCSDSpacket::createTmPkt $apid $pusType $pusSubType $hexData]
puts [CCSDSpacket::createTmPkt $apid $pusType $pusSubType $hexData]
puts [CCSDSpacket::createTmPkt $apid $pusType $pusSubType $hexData]

###########
# tests B #
###########

set apid 1234
set hexTmPack_0 "0CD2C000001A100319000000000000000000000000000000000000000000000000"
CCSDSpacket::resetSSC $apid
set hexTmPack_1 [CCSDSpacket::update $hexTmPack_0 true]
set hexTmPack_2 "0800C0000000100000000000000000000000000000000000000000000000000000"
set ssc 0
set packetLength 26
set pusType 3
set pusSubType 25
set hexTmPack_2 [CCSDSpacket::setAPID $hexTmPack_2 $apid]
set hexTmPack_2 [CCSDSpacket::setSSC $hexTmPack_2 $ssc]
set hexTmPack_2 [CCSDSpacket::setPacketLength $hexTmPack_2 $packetLength]
set hexTmPack_2 [CCSDSpacket::setPusType $hexTmPack_2 $pusType]
set hexTmPack_2 [CCSDSpacket::setPusSubType $hexTmPack_2 $pusSubType]
CCSDSpacket::resetSSC $apid
set packetData "000000000000000000000000000000"
set hexTmPack_3 [CCSDSpacket::createTmPkt $apid $pusType $pusSubType $packetData false false]
CCSDSpacket::resetSSC $apid
set packetData "00000000000000000000000000"
set hexTmPack_4 [CCSDSpacket::createTmPkt $apid $pusType $pusSubType $packetData]
puts "hexTmPack_0 = $hexTmPack_0"
puts "hexTmPack_1 = $hexTmPack_1"
puts "hexTmPack_2 = $hexTmPack_2"
puts "hexTmPack_3 = $hexTmPack_3"
puts "hexTmPack_4 = $hexTmPack_4"
puts "apid = [CCSDSpacket::getAPID $hexTmPack_0]"
puts "apid = [CCSDSpacket::getAPID $hexTmPack_1]"
puts "apid = [CCSDSpacket::getAPID $hexTmPack_2]"
puts "apid = [CCSDSpacket::getAPID $hexTmPack_3]"
puts "apid = [CCSDSpacket::getAPID $hexTmPack_4]"
puts "ssc = [CCSDSpacket::getSSC $hexTmPack_0]"
puts "ssc = [CCSDSpacket::getSSC $hexTmPack_1]"
puts "ssc = [CCSDSpacket::getSSC $hexTmPack_2]"
puts "ssc = [CCSDSpacket::getSSC $hexTmPack_3]"
puts "ssc = [CCSDSpacket::getSSC $hexTmPack_4]"
puts "packetLength = [CCSDSpacket::getPacketLength $hexTmPack_0]"
puts "packetLength = [CCSDSpacket::getPacketLength $hexTmPack_1]"
puts "packetLength = [CCSDSpacket::getPacketLength $hexTmPack_2]"
puts "packetLength = [CCSDSpacket::getPacketLength $hexTmPack_3]"
puts "packetLength = [CCSDSpacket::getPacketLength $hexTmPack_4]"
puts "pusType = [CCSDSpacket::getPusType $hexTmPack_0]"
puts "pusType = [CCSDSpacket::getPusType $hexTmPack_1]"
puts "pusType = [CCSDSpacket::getPusType $hexTmPack_2]"
puts "pusType = [CCSDSpacket::getPusType $hexTmPack_3]"
puts "pusType = [CCSDSpacket::getPusType $hexTmPack_4]"
puts "pusSubType = [CCSDSpacket::getPusSubType $hexTmPack_0]"
puts "pusSubType = [CCSDSpacket::getPusSubType $hexTmPack_1]"
puts "pusSubType = [CCSDSpacket::getPusSubType $hexTmPack_2]"
puts "pusSubType = [CCSDSpacket::getPusSubType $hexTmPack_3]"
puts "pusSubType = [CCSDSpacket::getPusSubType $hexTmPack_4]"
