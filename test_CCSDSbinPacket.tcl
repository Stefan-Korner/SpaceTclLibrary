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
set binData [binary format H* "FFFF"]
CCSDSpacket::resetSSC $apid
puts [bin2hex [CCSDSbinPacket::createTmPkt $apid $pusType $pusSubType $binData]]
puts [bin2hex [CCSDSbinPacket::createTmPkt $apid $pusType $pusSubType $binData]]
puts [bin2hex [CCSDSbinPacket::createTmPkt $apid $pusType $pusSubType $binData]]
puts [bin2hex [CCSDSbinPacket::createTmPkt $apid $pusType $pusSubType $binData]]
puts [bin2hex [CCSDSbinPacket::createTmPkt $apid $pusType $pusSubType $binData]]

###########
# tests B #
###########

set apid 1234
set binTmPack_0 [binary format H* "0CD2C000001A100319000000000000000000000000000000000000000000000000"]
CCSDSpacket::resetSSC $apid
set binTmPack_1 [CCSDSbinPacket::update $binTmPack_0 true]
set binTmPack_2 [binary format H* "0800C0000000100000000000000000000000000000000000000000000000000000"]
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
set packetData [binary format H* "000000000000000000000000000000"]
set binTmPack_3 [CCSDSbinPacket::createTmPkt $apid $pusType $pusSubType $packetData false false]
CCSDSpacket::resetSSC $apid
set packetData [binary format H* "00000000000000000000000000"]
set binTmPack_4 [CCSDSbinPacket::createTmPkt $apid $pusType $pusSubType $packetData]
puts "binTmPack_0 = [bin2hex $binTmPack_0]"
puts "binTmPack_1 = [bin2hex $binTmPack_1]"
puts "binTmPack_2 = [bin2hex $binTmPack_2]"
puts "binTmPack_3 = [bin2hex $binTmPack_3]"
puts "binTmPack_4 = [bin2hex $binTmPack_4]"
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
