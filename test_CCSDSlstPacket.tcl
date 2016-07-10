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

#set apid 1234
#set pusType 3
#set pusSubType 25
#set binData [hex2bin "ffff"]
#CCSDSpacket::resetSSC $apid
#puts [bin2hex [CCSDSlstPacket::createTmPkt $apid $pusType $pusSubType $binData]]
#puts [bin2hex [CCSDSlstPacket::createTmPkt $apid $pusType $pusSubType $binData]]
#puts [bin2hex [CCSDSlstPacket::createTmPkt $apid $pusType $pusSubType $binData]]
#puts [bin2hex [CCSDSlstPacket::createTmPkt $apid $pusType $pusSubType $binData]]
#puts [bin2hex [CCSDSlstPacket::createTmPkt $apid $pusType $pusSubType $binData]]

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
puts "lstTmPack_0 = [lst2hex $lstTmPack_0]"
puts "lstTmPack_1 = [lst2hex $lstTmPack_1]"
puts "lstTmPack_2 = [lst2hex $lstTmPack_2]"
puts "lstTmPack_3 = [lst2hex $lstTmPack_3]"
puts "lstTmPack_4 = [lst2hex $lstTmPack_4]"
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
