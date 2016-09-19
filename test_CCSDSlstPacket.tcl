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
# unit tests for CCSDS and PUS list packet processing                         *
#******************************************************************************
lappend auto_path $env(PWD)   # load procedures defined in tclIndex
namespace eval CCSDSlstPacket {}
namespace eval CCSDSpacket {}

###########
# tests A #
###########

set apid 1234
set pusType 3
set pusSubType 25
set lstData [hex2lst "ffff"]
CCSDSpacket::resetSSC $apid
set pkt1 [CCSDSlstPacket::createTmPkt $apid $pusType $pusSubType $lstData]
set pkt2 [CCSDSlstPacket::createTmPkt $apid $pusType $pusSubType $lstData]
set pkt3 [CCSDSlstPacket::createTmPkt $apid $pusType $pusSubType $lstData]
set pkt4 [CCSDSlstPacket::createTmPkt $apid $pusType $pusSubType $lstData]
set pkt5 [CCSDSlstPacket::createTmPkt $apid $pusType $pusSubType $lstData]
puts "pkt1 = [CCSDSlstPacket::dumpStr $pkt1]"
puts "pkt2 = [CCSDSlstPacket::dumpStr $pkt2]"
puts "pkt3 = [CCSDSlstPacket::dumpStr $pkt3]"
puts "pkt4 = [CCSDSlstPacket::dumpStr $pkt4]"
puts "pkt5 = [CCSDSlstPacket::dumpStr $pkt5]"

###########
# tests B #
###########

set apid 1234
set lstTmPack_0 [hex2lst "0cd2c000001a100319000000000000000000000000000000000000000000000000"]
CCSDSpacket::resetSSC $apid
set lstTmPack_1 $lstTmPack_0
CCSDSlstPacket::update lstTmPack_1 true
set lstTmPack_2 [hex2lst "0800c0000000100000000000000000000000000000000000000000000000000000"]
set ssc 0
set packetLength 26
set pusType 3
set pusSubType 25
set crc 0x9319
CCSDSlstPacket::setAPID lstTmPack_2 $apid
CCSDSlstPacket::setSSC lstTmPack_2 $ssc
CCSDSlstPacket::setPacketLength lstTmPack_2 $packetLength
CCSDSlstPacket::setPusType lstTmPack_2 $pusType
CCSDSlstPacket::setPusSubType lstTmPack_2 $pusSubType
CCSDSlstPacket::setCRC lstTmPack_2 $crc
CCSDSpacket::resetSSC $apid
set packetData [hex2lst "000000000000000000000000000000"]
set lstTmPack_3 [CCSDSlstPacket::createTmPkt $apid $pusType $pusSubType $packetData false false]
CCSDSpacket::resetSSC $apid
set packetData [hex2lst "00000000000000000000000000"]
set lstTmPack_4 [CCSDSlstPacket::createTmPkt $apid $pusType $pusSubType $packetData]
puts "lstTmPack_0 = [CCSDSlstPacket::dumpStr $lstTmPack_0]"
puts "lstTmPack_1 = [CCSDSlstPacket::dumpStr $lstTmPack_1]"
puts "lstTmPack_2 = [CCSDSlstPacket::dumpStr $lstTmPack_2]"
puts "lstTmPack_3 = [CCSDSlstPacket::dumpStr $lstTmPack_3]"
puts "lstTmPack_4 = [CCSDSlstPacket::dumpStr $lstTmPack_4]"
puts "length = [CCSDSlstPacket::byteLength $lstTmPack_0]"
puts "length = [CCSDSlstPacket::byteLength $lstTmPack_1]"
puts "length = [CCSDSlstPacket::byteLength $lstTmPack_2]"
puts "length = [CCSDSlstPacket::byteLength $lstTmPack_3]"
puts "length = [CCSDSlstPacket::byteLength $lstTmPack_4]"
puts "apid = [CCSDSlstPacket::getAPID $lstTmPack_0]"
puts "apid = [CCSDSlstPacket::getAPID $lstTmPack_1]"
puts "apid = [CCSDSlstPacket::getAPID $lstTmPack_2]"
puts "apid = [CCSDSlstPacket::getAPID $lstTmPack_3]"
puts "apid = [CCSDSlstPacket::getAPID $lstTmPack_4]"
puts "ssc = [CCSDSlstPacket::getSSC $lstTmPack_0]"
puts "ssc = [CCSDSlstPacket::getSSC $lstTmPack_1]"
puts "ssc = [CCSDSlstPacket::getSSC $lstTmPack_2]"
puts "ssc = [CCSDSlstPacket::getSSC $lstTmPack_3]"
puts "ssc = [CCSDSlstPacket::getSSC $lstTmPack_4]"
puts "packetLength = [CCSDSlstPacket::getPacketLength $lstTmPack_0]"
puts "packetLength = [CCSDSlstPacket::getPacketLength $lstTmPack_1]"
puts "packetLength = [CCSDSlstPacket::getPacketLength $lstTmPack_2]"
puts "packetLength = [CCSDSlstPacket::getPacketLength $lstTmPack_3]"
puts "packetLength = [CCSDSlstPacket::getPacketLength $lstTmPack_4]"
puts "pusType = [CCSDSlstPacket::getPusType $lstTmPack_0]"
puts "pusType = [CCSDSlstPacket::getPusType $lstTmPack_1]"
puts "pusType = [CCSDSlstPacket::getPusType $lstTmPack_2]"
puts "pusType = [CCSDSlstPacket::getPusType $lstTmPack_3]"
puts "pusType = [CCSDSlstPacket::getPusType $lstTmPack_4]"
puts "pusSubType = [CCSDSlstPacket::getPusSubType $lstTmPack_0]"
puts "pusSubType = [CCSDSlstPacket::getPusSubType $lstTmPack_1]"
puts "pusSubType = [CCSDSlstPacket::getPusSubType $lstTmPack_2]"
puts "pusSubType = [CCSDSlstPacket::getPusSubType $lstTmPack_3]"
puts "pusSubType = [CCSDSlstPacket::getPusSubType $lstTmPack_4]"
puts "crc = [CCSDSlstPacket::getCRC $lstTmPack_0]"
puts "crc = [CCSDSlstPacket::getCRC $lstTmPack_1]"
puts "crc = [CCSDSlstPacket::getCRC $lstTmPack_2]"
puts "crc = [CCSDSlstPacket::getCRC $lstTmPack_3]"
puts "crc = [CCSDSlstPacket::getCRC $lstTmPack_4]"
puts "isPusTmPacket = [CCSDSlstPacket::isPusTmPacket $lstTmPack_0]"
puts "isPusTmPacket = [CCSDSlstPacket::isPusTmPacket $lstTmPack_1]"
puts "isPusTmPacket = [CCSDSlstPacket::isPusTmPacket $lstTmPack_2]"
puts "isPusTmPacket = [CCSDSlstPacket::isPusTmPacket $lstTmPack_3]"
puts "isPusTmPacket = [CCSDSlstPacket::isPusTmPacket $lstTmPack_4]"
puts "isPusTcPacket = [CCSDSlstPacket::isPusTcPacket $lstTmPack_0]"
puts "isPusTcPacket = [CCSDSlstPacket::isPusTcPacket $lstTmPack_1]"
puts "isPusTcPacket = [CCSDSlstPacket::isPusTcPacket $lstTmPack_2]"
puts "isPusTcPacket = [CCSDSlstPacket::isPusTcPacket $lstTmPack_3]"
puts "isPusTcPacket = [CCSDSlstPacket::isPusTcPacket $lstTmPack_4]"

###########
# tests C #
###########

set lstPacket [hex2lst "30313233343536373839"]
set subLstPacket1 [CCSDSlstPacket::subPacket $lstPacket 0]
set subLstPacket2 [CCSDSlstPacket::subPacket $lstPacket 5]
set subLstPacket3 [CCSDSlstPacket::subPacket $lstPacket 5 4]
set subLstPacket4 [CCSDSlstPacket::subPacket $lstPacket 5 5]
set subLstPacket5 [CCSDSlstPacket::subPacket $lstPacket 5 6]
set subLstPacket6 [CCSDSlstPacket::subPacket $lstPacket 5 7]
puts "lstPacket = [CCSDSlstPacket::dumpStr $lstPacket]"
puts "isPusTmPacket = [CCSDSlstPacket::isPusTmPacket $lstPacket]"
puts "isPusTcPacket = [CCSDSlstPacket::isPusTcPacket $lstPacket]"
puts "subLstPacket1 = [CCSDSlstPacket::dumpStr $subLstPacket1]"
puts "subLstPacket2 = [CCSDSlstPacket::dumpStr $subLstPacket2]"
puts "subLstPacket3 = [CCSDSlstPacket::dumpStr $subLstPacket3]"
puts "subLstPacket4 = [CCSDSlstPacket::dumpStr $subLstPacket4]"
puts "subLstPacket5 = [CCSDSlstPacket::dumpStr $subLstPacket5]"
puts "subLstPacket6 = [CCSDSlstPacket::dumpStr $subLstPacket6]"
