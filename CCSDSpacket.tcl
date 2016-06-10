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

###################
# generic getters #
###################

# note: pktBytePos is the byte position of the value in the *binary* packet
proc CCSDSpacket::getUInt8 {hexPacket pktBytePos {mask 0xFF}} {
  set hexStartBytePos [expr $pktBytePos * 2]
  set hexEndBytePos [expr ($pktBytePos * 2) + 1]
  set hexValue [string range $hexPacket $hexStartBytePos $hexEndBytePos]
  scan $hexValue %x value
  return [expr $value & $mask]
}

proc CCSDSpacket::getUInt16 {hexPacket pktBytePos {mask 0xFFFF}} {
  set hexStartBytePos [expr $pktBytePos * 2]
  set hexEndBytePos [expr ($pktBytePos * 2) + 3]
  set hexValue [string range $hexPacket $hexStartBytePos $hexEndBytePos]
  scan $hexValue %x value
  return [expr $value & $mask]
}

proc CCSDSpacket::getUInt32 {hexPacket pktBytePos {mask 0xFFFFFFFF}} {
  set hexStartBytePos [expr $pktBytePos * 2]
  set hexEndBytePos [expr ($pktBytePos * 2) + 7]
  set hexValue [string range $hexPacket $hexStartBytePos $hexEndBytePos]
  scan $hexValue %x value
  return [expr $value & $mask]
}

###################
# generic setters #
###################

# note: pktBytePos is the byte position of the value in the *binary* packet
proc CCSDSpacket::setUInt8 {hexPacket pktBytePos value {mask 0xFF}} {
  set hexStartBytePos [expr $pktBytePos * 2]
  set hexEndBytePos [expr ($pktBytePos * 2) + 1]
  if {$mask != 0xFF} {
    # read
    set hexPacketValue [string range $hexPacket $hexStartBytePos $hexEndBytePos]
    # modify
    scan $hexPacketValue %x packetValue
    set inverseMask [expr $mask ^ 0xFF]
    set packetValue [expr $packetValue & $inverseMask]
    set value [expr $value | $packetValue]
  }
  # write
  set hexValue [format %02X $value]
  return [string replace $hexPacket $hexStartBytePos $hexEndBytePos $hexValue]
}

proc CCSDSpacket::setUInt16 {hexPacket pktBytePos value {mask 0xFFFF}} {
  set hexStartBytePos [expr $pktBytePos * 2]
  set hexEndBytePos [expr ($pktBytePos * 2) + 3]
  if {$mask != 0xFFFF} {
    # read
    set hexPacketValue [string range $hexPacket $hexStartBytePos $hexEndBytePos]
    # modify
    scan $hexPacketValue %x packetValue
    set inverseMask [expr $mask ^ 0xFFFF]
    set packetValue [expr $packetValue & $inverseMask]
    set value [expr $value | $packetValue]
  }
  # write
  set hexValue [format %04X $value]
  return [string replace $hexPacket $hexStartBytePos $hexEndBytePos $hexValue]
}

proc CCSDSpacket::setUInt32 {hexPacket pktBytePos value {mask 0xFFFFFFFF}} {
  set hexStartBytePos [expr $pktBytePos * 2]
  set hexEndBytePos [expr ($pktBytePos * 2) + 7]
  if {$mask != 0xFFFFFFFF} {
    # read
    set hexPacketValue [string range $hexPacket $hexStartBytePos $hexEndBytePos]
    # modify
    scan $hexPacketValue %x packetValue
    set inverseMask [expr $mask ^ 0xFFFFFFFF]
    set packetValue [expr $packetValue & $inverseMask]
    set value [expr $value | $packetValue]
  }
  # write
  set hexValue [format %08X $value]
  return [string replace $hexPacket $hexStartBytePos $hexEndBytePos $hexValue]
}

####################
# specific getters #
####################

# extracts the APID from a CCSDS packet
proc CCSDSpacket::getAPID {hexPacket} {
  return [getUInt16 $hexPacket 0 0x07FF]
}

# extracts the SSC from a CCSDS packet
proc CCSDSpacket::getSSC {hexPacket} {
  return [getUInt16 $hexPacket 2 0x3FFF]
}

# extracts the packet length from a CCSDS packet
proc CCSDSpacket::getPacketLength {hexPacket} {
  return [getUInt16 $hexPacket 4]
}

# extracts the PUS type from a PUS packet
proc CCSDSpacket::getPusType {hexPacket} {
  return [getUInt8 $hexPacket 7]
}

# extracts the PUS sub-type from a PUS packet
proc CCSDSpacket::getPusSubType {hexPacket} {
  return [getUInt8 $hexPacket 8]
}

####################
# specific setters #
####################

# sets the APID in a CCSDS packet
proc CCSDSpacket::setAPID {hexPacket apid} {
  return [setUInt16 $hexPacket 0 $apid 0x07FF]
}

# sets the SSC in a CCSDS packet
proc CCSDSpacket::setSSC {hexPacket ssc} {
  return [setUInt16 $hexPacket 2 $ssc 0x3FFF]
}

# sets the packet length field in a CCSDS packet
proc CCSDSpacket::setPacketLength {hexPacket packetLength} {
  return [setUInt16 $hexPacket 4 $packetLength]
}

# sets the PUS type in a PUS packet
proc CCSDSpacket::setPusType {hexPacket pusType} {
  return [setUInt8 $hexPacket 7 $pusType]
}

# sets the PUS sub-type in a PUS packet
proc CCSDSpacket::setPusSubType {hexPacket pusSubType} {
  return [setUInt8 $hexPacket 8 $pusSubType]
}

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

###################
# CRC calculation #
###################

# calculates the CRC from a packet
proc CCSDSpacket::calcCRC {hexPacket} {
  set s [binary format H* $hexPacket]
  set table {
    0x0000 0x1021 0x2042 0x3063 0x4084 0x50a5 0x60c6 0x70e7
    0x8108 0x9129 0xa14a 0xb16b 0xc18c 0xd1ad 0xe1ce 0xf1ef
    0x1231 0x0210 0x3273 0x2252 0x52b5 0x4294 0x72f7 0x62d6
    0x9339 0x8318 0xb37b 0xa35a 0xd3bd 0xc39c 0xf3ff 0xe3de
    0x2462 0x3443 0x0420 0x1401 0x64e6 0x74c7 0x44a4 0x5485
    0xa56a 0xb54b 0x8528 0x9509 0xe5ee 0xf5cf 0xc5ac 0xd58d
    0x3653 0x2672 0x1611 0x0630 0x76d7 0x66f6 0x5695 0x46b4
    0xb75b 0xa77a 0x9719 0x8738 0xf7df 0xe7fe 0xd79d 0xc7bc
    0x48c4 0x58e5 0x6886 0x78a7 0x0840 0x1861 0x2802 0x3823
    0xc9cc 0xd9ed 0xe98e 0xf9af 0x8948 0x9969 0xa90a 0xb92b
    0x5af5 0x4ad4 0x7ab7 0x6a96 0x1a71 0x0a50 0x3a33 0x2a12
    0xdbfd 0xcbdc 0xfbbf 0xeb9e 0x9b79 0x8b58 0xbb3b 0xab1a
    0x6ca6 0x7c87 0x4ce4 0x5cc5 0x2c22 0x3c03 0x0c60 0x1c41
    0xedae 0xfd8f 0xcdec 0xddcd 0xad2a 0xbd0b 0x8d68 0x9d49
    0x7e97 0x6eb6 0x5ed5 0x4ef4 0x3e13 0x2e32 0x1e51 0x0e70
    0xff9f 0xefbe 0xdfdd 0xcffc 0xbf1b 0xaf3a 0x9f59 0x8f78
    0x9188 0x81a9 0xb1ca 0xa1eb 0xd10c 0xc12d 0xf14e 0xe16f
    0x1080 0x00a1 0x30c2 0x20e3 0x5004 0x4025 0x7046 0x6067
    0x83b9 0x9398 0xa3fb 0xb3da 0xc33d 0xd31c 0xe37f 0xf35e
    0x02b1 0x1290 0x22f3 0x32d2 0x4235 0x5214 0x6277 0x7256
    0xb5ea 0xa5cb 0x95a8 0x8589 0xf56e 0xe54f 0xd52c 0xc50d
    0x34e2 0x24c3 0x14a0 0x0481 0x7466 0x6447 0x5424 0x4405
    0xa7db 0xb7fa 0x8799 0x97b8 0xe75f 0xf77e 0xc71d 0xd73c
    0x26d3 0x36f2 0x0691 0x16b0 0x6657 0x7676 0x4615 0x5634
    0xd94c 0xc96d 0xf90e 0xe92f 0x99c8 0x89e9 0xb98a 0xa9ab
    0x5844 0x4865 0x7806 0x6827 0x18c0 0x08e1 0x3882 0x28a3
    0xcb7d 0xdb5c 0xeb3f 0xfb1e 0x8bf9 0x9bd8 0xabbb 0xbb9a
    0x4a75 0x5a54 0x6a37 0x7a16 0x0af1 0x1ad0 0x2ab3 0x3a92
    0xfd2e 0xed0f 0xdd6c 0xcd4d 0xbdaa 0xad8b 0x9de8 0x8dc9
    0x7c26 0x6c07 0x5c64 0x4c45 0x3ca2 0x2c83 0x1ce0 0x0cc1
    0xef1f 0xff3e 0xcf5d 0xdf7c 0xaf9b 0xbfba 0x8fd9 0x9ff8
    0x6e17 0x7e36 0x4e55 0x5e74 0x2e93 0x3eb2 0x0ed1 0x1ef0
  } 
  set crc 0xFFFF
  binary scan $s c* data
  foreach {datum} $data {
    set crc [expr {[lindex $table [expr {(($crc >> 8) ^ $datum) & 0xFF}]] ^ ($crc << 8) & 0xFFFF}]
  }
  return $crc
}

#####################
# packet processing #
#####################

# efficient creation of a packet
proc CCSDSpacket::createTmPkt {apid pusType pusSubType hexData \
  {calcTime true} \
  {appendCrc true} \
  {pusHeaderByteSize 12} \
  {timeByteOffset 10} \
  {fineTimeByteSize 4}} \
{
  # APID
  set hdr0001 [expr $apid | 0x0800]
  set hdrx0001 [format %04X $hdr0001]
  # SSC
  set ssc [CCSDSpacket::getNextSSC $apid]
  set hdr0203 [expr $ssc | 0xC000]
  set hdrx0203 [format %04X $hdr0203]
  # packet length
  set allHeadersLength [expr 6 + $pusHeaderByteSize]
  set hexDataLength [string length $hexData]
  set dataLength [expr $hexDataLength / 2]
  set packetLength [expr $allHeadersLength + $dataLength]
  if {$appendCrc} {
    incr packetLength 2
  }
  set packetLengthValue [expr $packetLength - 7]
  set hdr0405 $packetLengthValue
  set hdrx0405 [format %04X $hdr0405]
  # PUS version
  set hdr06 0x10
  set hdrx06 [format %02X $hdr06]
  # PUS type
  set hdr07 $pusType
  set hdrx07 [format %02X $hdr07]
  # PUS sub-type
  set hdr08 $pusSubType
  set hdrx08 [format %02X $hdr08]
  # filler 1 and time stamp
  set fillerStartBytePos 9
  if {$calcTime} {
    # filler 1
    set fillerLength [expr $timeByteOffset - $fillerStartBytePos]
    set hdrxFill1 [string repeat "00" $fillerLength]
    incr fillerStartBytePos $fillerLength
    # coarse time
    set hdrxCoarse "00000000"
    incr fillerStartBytePos 4
    # fine time
    set hdrxFine [string repeat "00" $fineTimeByteSize]
    incr fillerStartBytePos $fineTimeByteSize
  } else {
    set hdrxFill1 ""
    set hdrxCoarse ""
    set hdrxFine ""
  }
  # filler 2
  set fillerLength [expr $allHeadersLength - $fillerStartBytePos]
  set hdrxFill2 [string repeat "00" $fillerLength]
  # packet without CRC
  set hexPacket ${hdrx0001}${hdrx0203}${hdrx0405}${hdrx06}${hdrx07}${hdrx08}${hdrxFill1}${hdrxCoarse}${hdrxFine}${hdrxFill2}${hexData}
  # CRC
  if {$appendCrc} {
    set crc [CCSDSpacket::calcCRC $hexPacket]
    set hexCRC [format %04X $crc]
    set hexPacket ${hexPacket}${hexCRC}
  }
  return $hexPacket
}

# updates the packet with the next SSC
proc CCSDSpacket::update {hexPacket calcCRC} {
  # update SSC
  set apid [CCSDSpacket::getAPID $hexPacket]
  set ssc [CCSDSpacket::getNextSSC $apid]
  set hexPacket [CCSDSpacket::setSSC $hexPacket $ssc]
  # update packet length
  set hexPacketLength [string length $hexPacket]
  set packetLengthValue [expr ($hexPacketLength / 2) - 7]
  set hexPacket [CCSDSpacket::setPacketLength $hexPacket $packetLengthValue]
  # update CRC
  if {$calcCRC} {
    set hexCrcPrevPos [expr $hexPacketLength - 5]
    set hexPacketWithoutCRC [string range $hexPacket 0 $hexCrcPrevPos] 
    set crc [CCSDSpacket::calcCRC $hexPacketWithoutCRC]
    set hexCRC [format %04X $crc]
    set hexPacket ${hexPacketWithoutCRC}${hexCRC}
  }
  return $hexPacket
}
