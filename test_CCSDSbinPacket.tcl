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
# unit tests for CCSDS and PUS binary packet processing                       *
#******************************************************************************
lappend auto_path $env(PWD)   # load procedures defined in tclIndex
namespace eval CCSDSbinPacket {}
namespace eval CCSDSpacket {}

###########
# tests A #
###########

set apid 1234
set pusType 3
set pusSubType 25
set binData [hex2bin "ffff"]
CCSDSpacket::resetSSC $apid
set pkt1 [CCSDSbinPacket::createTmPkt $apid $pusType $pusSubType $binData]
set pkt2 [CCSDSbinPacket::createTmPkt $apid $pusType $pusSubType $binData]
set pkt3 [CCSDSbinPacket::createTmPkt $apid $pusType $pusSubType $binData]
set pkt4 [CCSDSbinPacket::createTmPkt $apid $pusType $pusSubType $binData]
set pkt5 [CCSDSbinPacket::createTmPkt $apid $pusType $pusSubType $binData]
puts "pkt1 = [CCSDSbinPacket::dumpStr $pkt1]"
puts "pkt2 = [CCSDSbinPacket::dumpStr $pkt2]"
puts "pkt3 = [CCSDSbinPacket::dumpStr $pkt3]"
puts "pkt4 = [CCSDSbinPacket::dumpStr $pkt4]"
puts "pkt5 = [CCSDSbinPacket::dumpStr $pkt5]"

###########
# tests B #
###########

set apid 1234
set binTmPack_0 [hex2bin "0cd2c000001a100319000000000000000000000000000000000000000000000000"]
CCSDSpacket::resetSSC $apid
set binTmPack_1 [CCSDSbinPacket::update $binTmPack_0 true]
set binTmPack_2 [hex2bin "0800c0000000100000000000000000000000000000000000000000000000000000"]
set ssc 0
set packetLength 26
set pusType 3
set pusSubType 25
set crc 0x9319
set binTmPack_2 [CCSDSbinPacket::setAPID $binTmPack_2 $apid]
set binTmPack_2 [CCSDSbinPacket::setSSC $binTmPack_2 $ssc]
set binTmPack_2 [CCSDSbinPacket::setPacketLength $binTmPack_2 $packetLength]
set binTmPack_2 [CCSDSbinPacket::setPusType $binTmPack_2 $pusType]
set binTmPack_2 [CCSDSbinPacket::setPusSubType $binTmPack_2 $pusSubType]
set binTmPack_2 [CCSDSbinPacket::setCRC $binTmPack_2 $crc]
CCSDSpacket::resetSSC $apid
set packetData [hex2bin "000000000000000000000000000000"]
set binTmPack_3 [CCSDSbinPacket::createTmPkt $apid $pusType $pusSubType $packetData false false]
CCSDSpacket::resetSSC $apid
set packetData [hex2bin "00000000000000000000000000"]
set binTmPack_4 [CCSDSbinPacket::createTmPkt $apid $pusType $pusSubType $packetData]
puts "binTmPack_0 = [CCSDSbinPacket::dumpStr $binTmPack_0]"
puts "binTmPack_1 = [CCSDSbinPacket::dumpStr $binTmPack_1]"
puts "binTmPack_2 = [CCSDSbinPacket::dumpStr $binTmPack_2]"
puts "binTmPack_3 = [CCSDSbinPacket::dumpStr $binTmPack_3]"
puts "binTmPack_4 = [CCSDSbinPacket::dumpStr $binTmPack_4]"
puts "length = [CCSDSbinPacket::byteLength $binTmPack_0]"
puts "length = [CCSDSbinPacket::byteLength $binTmPack_1]"
puts "length = [CCSDSbinPacket::byteLength $binTmPack_2]"
puts "length = [CCSDSbinPacket::byteLength $binTmPack_3]"
puts "length = [CCSDSbinPacket::byteLength $binTmPack_4]"
puts "apid = [CCSDSbinPacket::getAPID $binTmPack_0]"
puts "apid = [CCSDSbinPacket::getAPID $binTmPack_1]"
puts "apid = [CCSDSbinPacket::getAPID $binTmPack_2]"
puts "apid = [CCSDSbinPacket::getAPID $binTmPack_3]"
puts "apid = [CCSDSbinPacket::getAPID $binTmPack_4]"
puts "ssc = [CCSDSbinPacket::getSSC $binTmPack_0]"
puts "ssc = [CCSDSbinPacket::getSSC $binTmPack_1]"
puts "ssc = [CCSDSbinPacket::getSSC $binTmPack_2]"
puts "ssc = [CCSDSbinPacket::getSSC $binTmPack_3]"
puts "ssc = [CCSDSbinPacket::getSSC $binTmPack_4]"
puts "packetLength = [CCSDSbinPacket::getPacketLength $binTmPack_0]"
puts "packetLength = [CCSDSbinPacket::getPacketLength $binTmPack_1]"
puts "packetLength = [CCSDSbinPacket::getPacketLength $binTmPack_2]"
puts "packetLength = [CCSDSbinPacket::getPacketLength $binTmPack_3]"
puts "packetLength = [CCSDSbinPacket::getPacketLength $binTmPack_4]"
puts "pusType = [CCSDSbinPacket::getPusType $binTmPack_0]"
puts "pusType = [CCSDSbinPacket::getPusType $binTmPack_1]"
puts "pusType = [CCSDSbinPacket::getPusType $binTmPack_2]"
puts "pusType = [CCSDSbinPacket::getPusType $binTmPack_3]"
puts "pusType = [CCSDSbinPacket::getPusType $binTmPack_4]"
puts "pusSubType = [CCSDSbinPacket::getPusSubType $binTmPack_0]"
puts "pusSubType = [CCSDSbinPacket::getPusSubType $binTmPack_1]"
puts "pusSubType = [CCSDSbinPacket::getPusSubType $binTmPack_2]"
puts "pusSubType = [CCSDSbinPacket::getPusSubType $binTmPack_3]"
puts "pusSubType = [CCSDSbinPacket::getPusSubType $binTmPack_4]"
puts "crc = [CCSDSbinPacket::getCRC $binTmPack_0]"
puts "crc = [CCSDSbinPacket::getCRC $binTmPack_1]"
puts "crc = [CCSDSbinPacket::getCRC $binTmPack_2]"
puts "crc = [CCSDSbinPacket::getCRC $binTmPack_3]"
puts "crc = [CCSDSbinPacket::getCRC $binTmPack_4]"
puts "isPusTmPacket = [CCSDSbinPacket::isPusTmPacket $binTmPack_0]"
puts "isPusTmPacket = [CCSDSbinPacket::isPusTmPacket $binTmPack_1]"
puts "isPusTmPacket = [CCSDSbinPacket::isPusTmPacket $binTmPack_2]"
puts "isPusTmPacket = [CCSDSbinPacket::isPusTmPacket $binTmPack_3]"
puts "isPusTmPacket = [CCSDSbinPacket::isPusTmPacket $binTmPack_4]"
puts "isPusTcPacket = [CCSDSbinPacket::isPusTcPacket $binTmPack_0]"
puts "isPusTcPacket = [CCSDSbinPacket::isPusTcPacket $binTmPack_1]"
puts "isPusTcPacket = [CCSDSbinPacket::isPusTcPacket $binTmPack_2]"
puts "isPusTcPacket = [CCSDSbinPacket::isPusTcPacket $binTmPack_3]"
puts "isPusTcPacket = [CCSDSbinPacket::isPusTcPacket $binTmPack_4]"

###########
# tests C #
###########

set binPacket [hex2bin "30313233343536373839"]
set subBinPacket1 [CCSDSbinPacket::subPacket $binPacket 0]
set subBinPacket2 [CCSDSbinPacket::subPacket $binPacket 5]
set subBinPacket3 [CCSDSbinPacket::subPacket $binPacket 5 4]
set subBinPacket4 [CCSDSbinPacket::subPacket $binPacket 5 5]
set subBinPacket5 [CCSDSbinPacket::subPacket $binPacket 5 6]
set subBinPacket6 [CCSDSbinPacket::subPacket $binPacket 5 7]
puts "binPacket = [CCSDSbinPacket::dumpStr $binPacket]"
puts "isPusTmPacket = [CCSDSbinPacket::isPusTmPacket $binPacket]"
puts "isPusTcPacket = [CCSDSbinPacket::isPusTcPacket $binPacket]"
puts "subBinPacket1 = [CCSDSbinPacket::dumpStr $subBinPacket1]"
puts "subBinPacket2 = [CCSDSbinPacket::dumpStr $subBinPacket2]"
puts "subBinPacket3 = [CCSDSbinPacket::dumpStr $subBinPacket3]"
puts "subBinPacket4 = [CCSDSbinPacket::dumpStr $subBinPacket4]"
puts "subBinPacket5 = [CCSDSbinPacket::dumpStr $subBinPacket5]"
puts "subBinPacket6 = [CCSDSbinPacket::dumpStr $subBinPacket6]"
