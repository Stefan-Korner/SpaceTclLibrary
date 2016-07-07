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
# unit tests for CCSDS and PUS hex packet processing                          *
#******************************************************************************
lappend auto_path $env(PWD)   # load procedures defined in tclIndex
namespace eval CCSDShexPacket {}
namespace eval CCSDSpacket {}

###########
# tests A #
###########

set apid 1234
set pusType 3
set pusSubType 25
set hexData "ffff"
CCSDSpacket::resetSSC $apid
puts [CCSDShexPacket::createTmPkt $apid $pusType $pusSubType $hexData]
puts [CCSDShexPacket::createTmPkt $apid $pusType $pusSubType $hexData]
puts [CCSDShexPacket::createTmPkt $apid $pusType $pusSubType $hexData]
puts [CCSDShexPacket::createTmPkt $apid $pusType $pusSubType $hexData]
puts [CCSDShexPacket::createTmPkt $apid $pusType $pusSubType $hexData]

###########
# tests B #
###########

set apid 1234
set hexTmPack_0 "0cd2c000001a100319000000000000000000000000000000000000000000000000"
CCSDSpacket::resetSSC $apid
set hexTmPack_1 [CCSDShexPacket::update $hexTmPack_0 true]
set hexTmPack_2 "0800c0000000100000000000000000000000000000000000000000000000000000"
set ssc 0
set packetLength 26
set pusType 3
set pusSubType 25
set crc 0x9319
set hexTmPack_2 [CCSDShexPacket::setAPID $hexTmPack_2 $apid]
set hexTmPack_2 [CCSDShexPacket::setSSC $hexTmPack_2 $ssc]
set hexTmPack_2 [CCSDShexPacket::setPacketLength $hexTmPack_2 $packetLength]
set hexTmPack_2 [CCSDShexPacket::setPusType $hexTmPack_2 $pusType]
set hexTmPack_2 [CCSDShexPacket::setPusSubType $hexTmPack_2 $pusSubType]
set hexTmPack_2 [CCSDShexPacket::setCRC $hexTmPack_2 $crc]
CCSDSpacket::resetSSC $apid
set packetData "000000000000000000000000000000"
set hexTmPack_3 [CCSDShexPacket::createTmPkt $apid $pusType $pusSubType $packetData false false]
CCSDSpacket::resetSSC $apid
set packetData "00000000000000000000000000"
set hexTmPack_4 [CCSDShexPacket::createTmPkt $apid $pusType $pusSubType $packetData]
puts "hexTmPack_0 = $hexTmPack_0"
puts "hexTmPack_1 = $hexTmPack_1"
puts "hexTmPack_2 = $hexTmPack_2"
puts "hexTmPack_3 = $hexTmPack_3"
puts "hexTmPack_4 = $hexTmPack_4"
puts "apid = [CCSDShexPacket::getAPID $hexTmPack_0]"
puts "apid = [CCSDShexPacket::getAPID $hexTmPack_1]"
puts "apid = [CCSDShexPacket::getAPID $hexTmPack_2]"
puts "apid = [CCSDShexPacket::getAPID $hexTmPack_3]"
puts "apid = [CCSDShexPacket::getAPID $hexTmPack_4]"
puts "ssc = [CCSDShexPacket::getSSC $hexTmPack_0]"
puts "ssc = [CCSDShexPacket::getSSC $hexTmPack_1]"
puts "ssc = [CCSDShexPacket::getSSC $hexTmPack_2]"
puts "ssc = [CCSDShexPacket::getSSC $hexTmPack_3]"
puts "ssc = [CCSDShexPacket::getSSC $hexTmPack_4]"
puts "packetLength = [CCSDShexPacket::getPacketLength $hexTmPack_0]"
puts "packetLength = [CCSDShexPacket::getPacketLength $hexTmPack_1]"
puts "packetLength = [CCSDShexPacket::getPacketLength $hexTmPack_2]"
puts "packetLength = [CCSDShexPacket::getPacketLength $hexTmPack_3]"
puts "packetLength = [CCSDShexPacket::getPacketLength $hexTmPack_4]"
puts "pusType = [CCSDShexPacket::getPusType $hexTmPack_0]"
puts "pusType = [CCSDShexPacket::getPusType $hexTmPack_1]"
puts "pusType = [CCSDShexPacket::getPusType $hexTmPack_2]"
puts "pusType = [CCSDShexPacket::getPusType $hexTmPack_3]"
puts "pusType = [CCSDShexPacket::getPusType $hexTmPack_4]"
puts "pusSubType = [CCSDShexPacket::getPusSubType $hexTmPack_0]"
puts "pusSubType = [CCSDShexPacket::getPusSubType $hexTmPack_1]"
puts "pusSubType = [CCSDShexPacket::getPusSubType $hexTmPack_2]"
puts "pusSubType = [CCSDShexPacket::getPusSubType $hexTmPack_3]"
puts "pusSubType = [CCSDShexPacket::getPusSubType $hexTmPack_4]"
puts "crc = [CCSDShexPacket::getCRC $hexTmPack_0]"
puts "crc = [CCSDShexPacket::getCRC $hexTmPack_1]"
puts "crc = [CCSDShexPacket::getCRC $hexTmPack_2]"
puts "crc = [CCSDShexPacket::getCRC $hexTmPack_3]"
puts "crc = [CCSDShexPacket::getCRC $hexTmPack_4]"
