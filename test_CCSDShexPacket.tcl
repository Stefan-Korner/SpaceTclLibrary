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
set pkt1 [CCSDShexPacket::createTmPkt $apid $pusType $pusSubType $hexData]
set pkt2 [CCSDShexPacket::createTmPkt $apid $pusType $pusSubType $hexData]
set pkt3 [CCSDShexPacket::createTmPkt $apid $pusType $pusSubType $hexData]
set pkt4 [CCSDShexPacket::createTmPkt $apid $pusType $pusSubType $hexData]
set pkt5 [CCSDShexPacket::createTmPkt $apid $pusType $pusSubType $hexData]
puts "pkt1 = [CCSDShexPacket::dumpStr $pkt1]"
puts "pkt2 = [CCSDShexPacket::dumpStr $pkt2]"
puts "pkt3 = [CCSDShexPacket::dumpStr $pkt3]"
puts "pkt4 = [CCSDShexPacket::dumpStr $pkt4]"
puts "pkt5 = [CCSDShexPacket::dumpStr $pkt5]"

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
puts "hexTmPack_0 = [CCSDShexPacket::dumpStr $hexTmPack_0]"
puts "hexTmPack_1 = [CCSDShexPacket::dumpStr $hexTmPack_1]"
puts "hexTmPack_2 = [CCSDShexPacket::dumpStr $hexTmPack_2]"
puts "hexTmPack_3 = [CCSDShexPacket::dumpStr $hexTmPack_3]"
puts "hexTmPack_4 = [CCSDShexPacket::dumpStr $hexTmPack_4]"
puts "length = [CCSDShexPacket::byteLength $hexTmPack_0]"
puts "length = [CCSDShexPacket::byteLength $hexTmPack_1]"
puts "length = [CCSDShexPacket::byteLength $hexTmPack_2]"
puts "length = [CCSDShexPacket::byteLength $hexTmPack_3]"
puts "length = [CCSDShexPacket::byteLength $hexTmPack_4]"
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
puts "isPusTmPacket = [CCSDShexPacket::isPusTmPacket $hexTmPack_0]"
puts "isPusTmPacket = [CCSDShexPacket::isPusTmPacket $hexTmPack_1]"
puts "isPusTmPacket = [CCSDShexPacket::isPusTmPacket $hexTmPack_2]"
puts "isPusTmPacket = [CCSDShexPacket::isPusTmPacket $hexTmPack_3]"
puts "isPusTmPacket = [CCSDShexPacket::isPusTmPacket $hexTmPack_4]"
puts "isPusTcPacket = [CCSDShexPacket::isPusTcPacket $hexTmPack_0]"
puts "isPusTcPacket = [CCSDShexPacket::isPusTcPacket $hexTmPack_1]"
puts "isPusTcPacket = [CCSDShexPacket::isPusTcPacket $hexTmPack_2]"
puts "isPusTcPacket = [CCSDShexPacket::isPusTcPacket $hexTmPack_3]"
puts "isPusTcPacket = [CCSDShexPacket::isPusTcPacket $hexTmPack_4]"

###########
# tests C #
###########

set hexPacket "30313233343536373839"
set subHexPacket1 [CCSDShexPacket::subPacket $hexPacket 0]
set subHexPacket2 [CCSDShexPacket::subPacket $hexPacket 5]
set subHexPacket3 [CCSDShexPacket::subPacket $hexPacket 5 4]
set subHexPacket4 [CCSDShexPacket::subPacket $hexPacket 5 5]
set subHexPacket5 [CCSDShexPacket::subPacket $hexPacket 5 6]
set subHexPacket6 [CCSDShexPacket::subPacket $hexPacket 5 7]
puts "hexPacket = [CCSDShexPacket::dumpStr $hexPacket]"
puts "isPusTmPacket = [CCSDShexPacket::isPusTmPacket $hexPacket]"
puts "isPusTcPacket = [CCSDShexPacket::isPusTcPacket $hexPacket]"
puts "subHexPacket1 = [CCSDShexPacket::dumpStr $subHexPacket1]"
puts "subHexPacket2 = [CCSDShexPacket::dumpStr $subHexPacket2]"
puts "subHexPacket3 = [CCSDShexPacket::dumpStr $subHexPacket3]"
puts "subHexPacket4 = [CCSDShexPacket::dumpStr $subHexPacket4]"
puts "subHexPacket5 = [CCSDShexPacket::dumpStr $subHexPacket5]"
puts "subHexPacket6 = [CCSDShexPacket::dumpStr $subHexPacket6]"
